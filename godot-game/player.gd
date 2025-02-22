extends CharacterBody2D

const SPEED = 20.0
const JUMP_VELOCITY = -400.0

var char_name = "Boat"

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
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
