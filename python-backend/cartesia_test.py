import os
import subprocess
from cartesia import Cartesia

client = Cartesia(api_key="sk_car_a-pJptqZnk6G3os7sR5u-") #os.environ.get("CARTESIA_API_KEY"))

data = client.tts.bytes(
    model_id="sonic",
    transcript="Hello, world! I'm generating audio on Cartesia.",
    voice_id="694f9389-aac1-45b6-b726-9d9369183238",  # Barbershop Man
    # You can find the supported `output_format`s at https://docs.cartesia.ai/api-reference/tts/bytes
    output_format={
        "container": "wav",
        "encoding": "pcm_f32le",
        "sample_rate": 44100,
    },
)

with open("sonic.wav", "wb") as f:
    f.write(data)
