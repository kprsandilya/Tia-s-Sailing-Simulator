extends Node

@export var API_URL : String = "https://api.cartesia.ai/tts/bytes"  # Update to the correct URL
@export var API_KEY : String = "sk_car_a-pJptqZnk6G3os7sR5u-"  # Use your actual API key
@onready var request = HTTPRequest.new()

func _ready():
	add_child(request)

	# Prepare headers for the request
	var headers = PackedStringArray()
	headers.append("Content-Type: application/json")
	headers.append("X-API-Key: " + API_KEY)
	headers.append("Cartesia-Version: 2024-06-10")  # Add the required version header

	# Prepare the data for the request (the text-to-speech data)
	var data = {
		"transcript": "Welcome to Cartesia Sonic!",
		"model_id": "sonic",
		"voice": {
			"mode": "id",
			"id": "694f9389-aac1-45b6-b726-9d9369183238"  # Barbershop Man
		},
		"output_format": {
			"container": "wav",
			"encoding": "pcm_f32le",
			"sample_rate": 44100
		}
	}

	# Convert data to JSON string
	var json_data = JSON.stringify(data)

	# Connect the request completion signal
	request.request_completed.connect(self._on_request_completed)

	# Send the request
	var err = request.request(API_URL, headers, HTTPClient.METHOD_POST, json_data)

	if err == OK:
		print("Request sent successfully.")
	else:
		print("Request failed with error: ", err)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	print("Request completed.")
	print("Result: ", result)
	print("Response Code: ", response_code)
	
	# If the response is binary data (audio), do not convert it to a string
	# Directly write the response body (the binary data) to a file
	if response_code == 200:
		print("Audio data received successfully.")
		
		# Save the response body (which should be the audio data) as a file
		var file = FileAccess.open("res://sonic.wav", FileAccess.WRITE)
		if file:
			file.store_buffer(body)  # Store the binary audio data
			file.close()  # Always close the file when done
			print("Audio file saved successfully.")
		else:
			print("Failed to open file for writing.")
	else:
		print("Error receiving audio. Response code: ", response_code)
		print("Response Body (text): ", body.get_string_from_utf8())  # Optional: print the text response for debugging
