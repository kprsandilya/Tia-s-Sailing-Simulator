extends CharacterBody2D

@onready var fishing_bar = get_node("./Hud/fishing_bar")

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

func get_game_state() -> Array:
	return [hunger_state, fish_count, clownfish_count, shark_count, collected_clownfish, collected_clownfish, collected_shark]

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
			collected_fish = 1
			fish_count += 1
			inventory_node.catchFish()
		2:
			notificatoin_string = "YOU CAUGHT A CLOWNFISH!"
			collected_clownfish = 1
			clownfish_count += 1
			inventory_node.catchClownFish()
		3:
			notificatoin_string = "YOU CAUGHT A SHARK!"
			collected_shark = 1
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
