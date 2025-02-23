extends Node
@onready var request = HTTPRequest.new()

@export var voice_API_URL : String = "https://api.cartesia.ai/tts/bytes"  # Update to the correct URL
@onready var voice_request = HTTPRequest.new()

var API_URL = ""
var API_KEY = ""
var voice_API_KEY = ""

# Declare the AudioStreamPlayer in the script
var audio_player: AudioStreamPlayer

func _on_button_pressed() -> void:
	var file: String = FileAccess.get_file_as_string("res://.env")
	var lines: PackedStringArray = []
	
	var env = {}
	lines = file.split("\n")
	for line in lines:
		if line != "":
			var o = line.split("=")
			env[o[0]] = o[1]
	
	API_URL = env['MODAL_RUN'] + "/v1/completions"
	API_KEY = env['MODAL_API_KEY']
	
	voice_API_KEY = env['CARTESIA_API_KEY']
	
	print(API_URL + " " +  API_KEY + " " + voice_API_KEY)
	
	add_child(request)
	
	# Prepare headers and payload for the request
	var headers = PackedStringArray()
	headers.append("Content-Type: application/json")
	headers.append("Authorization: Bearer " + API_KEY)

	# Prepare the data for the request (from the user input)
	var payload = {
		"input": "Who am I?",
		"api_key": API_KEY
	}

	var data = {
		"model": "neuralmagic/Meta-Llama-3.1-8B-Instruct-quantized.w4a16",
		"prompt": [payload["input"]],  # Wrap input in a list
		"max_tokens": 200,
		"temperature": 0.7,
		"top_p": 0.9,
		"n": 1,
		"stop": "\n"
	}
	
	print("Request preparing...")

	request.request_completed.connect(self._on_request_completed)
	
	print("Sending request...")

	var json_data = JSON.stringify(data)  # Convert data to JSON string
	var err = request.request(API_URL, headers, HTTPClient.METHOD_POST, json_data)
	
	print("Request sent with status: ", err)

	# Set a timeout for the request to avoid hanging forever
	request.set_timeout(10)  # Timeout in seconds

	print("Request attempt complete.")

# For the text completion request
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	print("Request completed.")
	print("Result: ", result)
	print("Response Code: ", response_code)
	print("Response Headers: ", headers)
	
	var string = body.get_string_from_ascii()
	print("Response Body: ", string)
	
	if response_code == 200:
		var parsed_json = JSON.parse_string(string)
		var final_string = parsed_json['choices'][0]['text']
		print("Received text: ", final_string.strip_edges())
		
		# Proceed to voice request
		_send_voice_request(final_string)
	else:
		print("Text Completion Error: ", response_code)

# For the voice request (TTS)
func _send_voice_request(final_string: String) -> void:
	add_child(voice_request)
	
	var voice_headers = PackedStringArray()
	voice_headers.append("Content-Type: application/json")
	voice_headers.append("X-API-Key: " + voice_API_KEY)
	voice_headers.append("Cartesia-Version: 2024-06-10")

	# Prepare the data for the request (the text-to-speech data)
	var voice_data = {
		"transcript": final_string,
		"model_id": "sonic",
		"voice": {
			"mode": "id",
			"id": "694f9389-aac1-45b6-b726-9d9369183238"  # Barbershop Man
		},
		"output_format": {
			"container": "mp3",
			"bit_rate": 32000,
			"sample_rate": 44100
		}
	}
	
	#print(final_string)

	var voice_json_data = JSON.stringify(voice_data)
	
	voice_request.request_completed.connect(self._on_voice_request_completed)

	# Send the voice request
	var err = voice_request.request(voice_API_URL, voice_headers, HTTPClient.METHOD_POST, voice_json_data)
	
	print(err)

	if err != OK:
		print("Voice Request Failed with error: ", err)
	else:
		print("Voice request sent successfully.")

signal file_deleted_and_ready_to_play

func _on_voice_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	print("Voice Request completed.")
	print("Result: ", result)
	print("Response Code: ", response_code)

	if response_code == 200:
		# Save audio file to user:// directory
		var file_path = "user://sonic.mp3"  # Save it in the user:// directory
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		if file:
			# Delete the existing audio file if it exists
			var previous_file = FileAccess.open(file_path, FileAccess.READ)
			if previous_file:
				DirAccess.remove_absolute(file_path)
				print("Previous audio file deleted.")
				
			
			file.store_buffer(body)
			file.close()
			
			await get_tree().create_timer(1.0).timeout
			
			_on_file_deleted_and_ready_to_play(body)
		else:
			print("Failed to open file for writing.")
	else:
		print("Error receiving audio. Response code: ", response_code)
		print("Response Body: ", body.get_string_from_utf8())  # Print text response for debugging

# Function to play the audio after the file is deleted
func _on_file_deleted_and_ready_to_play(body) -> void:
	var audio_player = $AudioStreamPlayer  # Ensure this is your AudioStreamPlayer node
	print("File deleted. Now loading and playing the new audio.")
	var file_path = "user://sonic.mp3"  # Path to the new audio file

	var file = FileAccess.open(file_path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	audio_player.stream = sound  # Set the audio stream
	audio_player.play()  # Play the audio
	print("MP3 is now playing!")
