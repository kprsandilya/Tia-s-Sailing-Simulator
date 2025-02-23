import modal
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess
import requests
from requests.exceptions import Timeout, RequestException
import os

# import shutil
# from dotenv import load_dotenv

# # Define paths
# local_env_path = "../.env"  # Adjust if needed
# modal_env_path = "./.env"  # Destination inside the container

# # Copy .env into the container if it doesn't exist
# if not os.path.exists(modal_env_path) and os.path.exists(local_env_path):
#     shutil.copy(local_env_path, modal_env_path)

# # Load the .env file from the new location
# load_dotenv(dotenv_path=modal_env_path)

# # Access the environment variable
# API_KEY = os.getenv("MODAL_API_KEY")
# MODAL_RUN = os.getenv("MODAL_RUN")
# print(API_KEY, MODAL_RUN)

# Define Modal image and environment
vllm_image = (
    modal.Image.debian_slim(python_version="3.12")
    .pip_install(
        "vllm==0.7.2",
        "huggingface_hub[hf_transfer]==0.26.2",
        "flashinfer-python==0.2.0.post2",  # pinning, very unstable
        extra_index_url="https://flashinfer.ai/whl/cu124/torch2.5",
    )
    .env({"HF_HUB_ENABLE_HF_TRANSFER": "1"})  # faster model transfers
)

vllm_image = vllm_image.env({"VLLM_USE_V1": "1"})

# Define model parameters
MODEL_NAME = "neuralmagic/Meta-Llama-3.1-8B-Instruct-quantized.w4a16"
MODEL_REVISION = "a7c09948d9a632c2c840722f519672cd94af885d"

# Attach volumes for caching
hf_cache_vol = modal.Volume.from_name("huggingface-cache", create_if_missing=True)
vllm_cache_vol = modal.Volume.from_name("vllm-cache", create_if_missing=True)

N_GPU = 1
#API_KEY = "super-secret-key"  # For production, store this in modal.Secret
VLLM_PORT = 8000
MINUTES = 60  

app = modal.App("SailingSimulator")

@app.function(
    image=vllm_image,
    gpu=f"H100:{N_GPU}",
    allow_concurrent_inputs=100,
    container_idle_timeout=15 * MINUTES,
    volumes={
        "/root/.cache/huggingface": hf_cache_vol,
        "/root/.cache/vllm": vllm_cache_vol,
    }, secrets=[modal.Secret.from_name("my_secret")]
)
@modal.web_server(port=VLLM_PORT, startup_timeout=5 * MINUTES)
def serve():
    API_KEY=os.getenv("MODAL_API_KEY")

    """Starts the VLLM model server and exposes a FastAPI endpoint."""
    # Start VLLM server in the background
    cmd = [
        "vllm",
        "serve",
        "--uvicorn-log-level=info",
        MODEL_NAME,
        "--revision",
        MODEL_REVISION,
        "--host",
        "0.0.0.0",
        "--port",
        str(VLLM_PORT),
        "--api-key",
        API_KEY,
    ]
    subprocess.Popen(" ".join(cmd), shell=True)

    # Initialize FastAPI app
    api = FastAPI()

    class QueryRequest(BaseModel):
        input: str
        api_key: str

    @api.get("/health")
    async def health_check():
        return {"status": "ok"}

    # This will make FastAPI routes available at the correct URL
    return api