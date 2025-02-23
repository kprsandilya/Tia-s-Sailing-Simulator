extends CharacterBody2D

@onready var fishing_bar = get_node("./Hud/fishing_bar")

@onready var request = HTTPRequest.new()

@export var voice_API_URL : String = "https://api.cartesia.ai/tts/bytes"  # Update to the correct URL
@onready var voice_request = HTTPRequest.new()

var API_URL = ""
var API_KEY = ""
var voice_API_KEY = ""

# Declare the AudioStreamPlayer in the script
var audio_player: AudioStreamPlayer

var current_fishing_spot = null
var can_interact := false
var is_holding := false
var progress_time := 0.0
var SPEED = 50.0
const HOLD_TIME = 3.0

#Game state
var hunger_state = 0
var fish_count = 0
var clownfish_count = 0
var shark_count = 0
var collected_fish = 0      #false
var collected_clownfish = 0 #false
var collected_shark = 0     #false

var char_name = "./Boat"

func _ready():
	pass

func get_game_state() -> String:
	return "Hunger: " + str(hunger_state) + " Fish Count: " + str(fish_count) + " Clownfish Count: " + str(clownfish_count) + \
	 " Shark Count: " + str(shark_count) + " Collected First Time: " + str(collected_fish) + " Collected Clownfish: " + \
	str(collected_clownfish) + " Collected " + str(collected_shark)

func _process(delta):
	#print("Player Position: ", position)

	#Fishing
	if can_interact and Input.is_action_pressed("ui_interact"):
		SPEED = 0
		get_node("./Hud").hide_fishing_tooltip()
		if not is_holding:
			is_holding = true
			fishing_bar.visible = true
			fishing_bar.value = 0

		progress_time += delta
		fishing_bar.value = (progress_time / HOLD_TIME) * 100

		if progress_time >= HOLD_TIME:
			complete_fish()
	else:
		SPEED = 50
		if is_holding:
			reset_progress_bar()

func _physics_process(delta: float) -> void:		
	var input_vector = Vector2.ZERO
	
	#Wrap around world
	if position.y < -83.33335:
		position.y = 76.66666
	if position.y > 76.66667:
		position.y = -83.33335
	if position.x < -131.6668:
		position.x = 124.1668
	if position.x > 124.1669:
		position.x = -131.6668
	
	#Player movement
	#	Cardinal
	if Input.is_action_pressed("ui_up"):
		get_node("./" + char_name).play("up")
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		get_node("./" + char_name).play("down")
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		get_node("./" + char_name).play("left")
		get_node("./" + char_name).flip_h = false
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		get_node("./" + char_name).play("left")
		get_node("./" + char_name).flip_h = true
		input_vector.x += 1
	#	Diagonals
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		get_node("./" + char_name).play("nw")
		get_node("./" + char_name).flip_h = false
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		get_node("./" + char_name).play("nw")
		get_node("./" + char_name).flip_h = true
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		get_node("./" + char_name).play("sw")
		get_node("./" + char_name).flip_h = false
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		get_node("./" + char_name).play("sw")
		get_node("./" + char_name).flip_h = true
	
	velocity = input_vector * SPEED

	move_and_slide()

#
func complete_fish():
	print("Fishing completed!")
	#Visuals
	reset_progress_bar()
	if current_fishing_spot:
		current_fishing_spot.queue_free()
		current_fishing_spot = null
		#Spawn new fish
		get_node("/root/Game").spawn_fish()
	#Pick fish
	var fish_num = randi_range(1, 3)
	#update inventory
	var inventory_node = get_node("./inventory_menu")
	var fish_notification_label = get_node("./Hud/fish_notification")
	var notificatoin_string = ""
	match fish_num:
		1:
			notificatoin_string = "YOU CAUGHT A FISH!"
			collected_fish += 1
			fish_count += 1
			inventory_node.catchFish()
		2:
			notificatoin_string = "YOU CAUGHT A CLOWNFISH!"
			collected_clownfish += 1
			clownfish_count += 1
			inventory_node.catchClownFish()
		3:
			notificatoin_string = "YOU CAUGHT A SHARK!"
			collected_shark += 1
			clownfish_count += 1 
			inventory_node.catchShark()
	
	fish_notification_label.show()
	fish_notification_label.text = notificatoin_string
	await get_tree().create_timer(2.0).timeout
	fish_notification_label.hide()
	
func reset_progress_bar():
	progress_time = 0.0
	fishing_bar.value = 0.0
	is_holding = false
	#fishing_bar.visible = false

#Detect fishing spots
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "fishing_spot_area":
		print("You can fish here")
		current_fishing_spot = area.get_parent()
		can_interact = true
		get_node("./Hud").show_fishing_tooltip()
		#get_node("/root/Game/fishing_spot/").show_tooltip()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "fishing_spot_area":
		print("Exited fishing spot")
		can_interact = false
		current_fishing_spot = null
		#reset_progress_bar()
		get_node("./Hud").hide_fishing_bar()
		get_node("./Hud").hide_fishing_tooltip()
		#get_node("/root/Game/fishing_spot/").hide_tooltip()
		
func _on_button_pressed() -> void:
	#var input = "Summarize my current game state in one or two concise sentences: " + get_game_state()
	var input = "As a marine biologist, provide a rare or surprising fact about a deep-sea creature in a some sentences."
	
	print(input)
	
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
		"input": input,
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
			"id": "cccc21e8-5bcf-4ff0-bc7f-be4e40afc544"  # Barbershop Man
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
