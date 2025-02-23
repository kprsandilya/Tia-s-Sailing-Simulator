extends CharacterBody2D

const SPEED = 50.0

var char_name = "./Boat"
@onready var fishing_prompt = get_node("./AnimatedSprite2D/fishing_spot/fishing_label")

func _ready():
	pass

#func _process(delta):
	#print("Player Position: ", position)

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

#Detect fishing spots
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "fishing_spot_area":
		print("You can fish here")
		get_node("/root/Game/fishing_spot/").show_tooltip()
		
	#pass # Replace with function body.
