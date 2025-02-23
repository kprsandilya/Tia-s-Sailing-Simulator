import requests

from dotenv import load_dotenv
import os
from pathlib import Path

# Get the parent directory (one level up)
env_path = Path(__file__).resolve().parent.parent / "godot-game/.env"

# Load the .env file from the specified path
load_dotenv(dotenv_path=env_path)

# Access the environment variable
API_KEY = os.getenv("MODAL_API_KEY")
MODAL_RUN = os.getenv("MODAL_RUN")

# Replace with your actual Modal deployment URL
API_URL = MODAL_RUN + "/v1/completions"
#API_KEY = "super-secret-key"  # Use your actual API key

# Now make the prediction request
headers = {
	"Content-Type": "application/json"
}

payload = {
	"input" : "Who am I?",
	"api_key": API_KEY  # Send the API key in the body
}

try:
	# Prepare the data for the request (from the user input)
	data = {
		"model": "neuralmagic/Meta-Llama-3.1-8B-Instruct-quantized.w4a16",
		"prompt": [payload['input']],  # Wrap input in a list, as per the 'curl' example
		"max_tokens": 200,
		"temperature": 0.7,
		"top_p": 0.9,
		"n": 1,
		"stop": "\n"
	}

	headers = {
		"Content-Type": "application/json",
		"Authorization": f"Bearer {payload['api_key']}"
	}

	# Send the query to the Modal model
	response = requests.post(
		API_URL,
		json=data,
		headers=headers,
		timeout=300  # Timeout for the request
	)

	print(response.json())

except requests.exceptions.RequestException as e:
	print(f"Error making prediction request: {e}")
