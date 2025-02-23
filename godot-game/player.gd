extends CharacterBody2D

<<<<<<< Updated upstream
@onready var progress_bar = get_node("./Hud/fishing_bar")
=======
@onready var progress_bar = get_node("./Hud/fish_bar")  # Reference ProgressBar node
>>>>>>> Stashed changes

var can_interact := false
var is_holding := false
var progress_time := 0.0
const SPEED = 50.0
<<<<<<< Updated upstream
const HOLD_TIME = 3.0
=======
const HOLD_TIME = 5.0
>>>>>>> Stashed changes

var char_name = "./Boat"

func _ready():
	pass

func _process(delta):
<<<<<<< Updated upstream
=======
	if can_interact and Input.is_action_pressed("ui_interact"):
		if not is_holding:
			is_holding = true
			progress_bar.visible = true
			progress_bar.value = 0

			progress_time += delta
			progress_bar.value = (progress_time / HOLD_TIME) * 100

			if progress_time >= HOLD_TIME:
				complete_action()
			else:
				if is_holding:
					reset_progress_bar()
>>>>>>> Stashed changes
	#print("Player Position: ", position)
	if can_interact and Input.is_action_pressed("ui_interact"):
		get_node("./Hud").hide_fishing_tooltip()
		#get_node("./Hud").show_fishing_bar()
		if not is_holding:
			is_holding = true
			progress_bar.visible = true
			progress_bar.value = 0

		progress_time += delta
		progress_bar.value = (progress_time / HOLD_TIME) * 100
		print("Progress value: ", progress_bar.value)

		if progress_time >= HOLD_TIME:
			complete_action()
	else:
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
	
	velocity = input_vector * SPEED

	move_and_slide()

#
func complete_action():
	print("Action completed!")  # Replace with actual functionality
	reset_progress_bar()

func reset_progress_bar():
	progress_time = 0.0
	is_holding = false
<<<<<<< Updated upstream
	#progress_bar.visible = false
=======
	progress_bar.visible = false
>>>>>>> Stashed changes

#Detect fishing spots
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "fishing_spot_area":
		print("You can fish here")
		can_interact = true
		get_node("./Hud").show_fishing_tooltip()
		#get_node("/root/Game/fishing_spot/").show_tooltip()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "fishing_spot_area":
		print("Exited fishing spot")
		can_interact = false
		reset_progress_bar()
		get_node("./Hud").hide_fishing_tooltip()
		#get_node("/root/Game/fishing_spot/").hide_tooltip()
