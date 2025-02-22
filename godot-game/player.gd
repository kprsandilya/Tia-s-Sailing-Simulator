extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var motion = Vector2.ZERO
var screen_size # Size of the game window.
var scaler = 6
var xscaler = scaler * 5
var yscaler = scaler * 7
var char_name = "Tia"

func _ready():
	screen_size = get_viewport_rect().size

func set_new_name(new_name):
	char_name = new_name
	print(char_name)

func _physics_process(delta):

	#if (char_name == "Timmy"):
	#	$Tia.hide()
	#	$Timmy.show()
	#else:
	#	$Tia.show()
	#	$Timmy.hide()
	#print(player.char_name)
	
	$Boat.show()
	
	#Test
	if Input.is_action_pressed("ui_right"):
		get_node("./" + char_name).play("sidewalk")
		get_node("./" + char_name).flip_h = true
		motion.x = speed
		motion.y = 0
	elif Input.is_action_pressed("ui_left"):
		get_node("./" + char_name).play("sidewalk")
		get_node("./" + char_name).flip_h = false
		motion.x = -speed
		motion.y = 0
	if Input.is_action_pressed("ui_down"):
		get_node("./" + char_name).play("downwalk")
		motion.y = speed
		if Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left"):
			motion.x = 0
	elif Input.is_action_pressed("ui_up"): 
		get_node("./" + char_name).play("upwalk")
		motion.y = -speed
		if Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left"):
			motion.x = 0
		
	if (!Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left") 
		&& !Input.is_action_pressed("ui_down") && !Input.is_action_pressed("ui_up")):
		get_node("./" + char_name).play("idle")
		motion.x = 0
		motion.y = 0
		
	velocity = motion
	position += velocity * delta
	position = position.clamp(Vector2(xscaler,yscaler), Vector2(screen_size.x - xscaler, screen_size.y - yscaler))
