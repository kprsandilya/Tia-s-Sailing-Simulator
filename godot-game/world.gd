extends Node2D

# extends Node

@onready var fishing_spot_scene = preload("res://fishing_spot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):  # Spawn 5 random objects
		spawn_fish()
	#pass # Replace with function body.

func spawn_fish():
	print("Spawned Fish")
	var new_object = fishing_spot_scene.instantiate()
	new_object.position = Vector2(randi_range(-131, 124), randi_range(-83, 76))
	new_object.z_index = 0
	add_child(new_object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_input(delta)
	time()
	var nodes = get_tree().get_nodes_in_group("HUD")
	# pass


@onready var background = $background

var ground_layer = 0

@onready var player_tile_pos : Vector2i = background.local_to_map($player.position)

var can_till_custom_data = "can_till"

func time():
	pass
	#if ($Timer.get_time_left() < 10.5):
		#$background.set_layer_enabled(1, true)
	#else:
		#$background.set_layer_enabled(1, false)

func _input(event):
	player_tile_pos = background.local_to_map(background.to_local($player.position))
	
	#var tile_data : TileData = background.get_cell_tile_data(ground_layer, player_tile_pos)
	#var source_id = 0
	#var atlas_coord = Vector2i(0,0)
	
	#var enable = get_tree().create_timer(.9)
	
	#var loop_number = 1
	
	#if Input.is_action_just_pressed("till"):
		
		#tile_data = background.get_cell_tile_data(ground_layer, player_tile_pos)
		#source_id = 0
		#atlas_coord = Vector2i(4,7)
		
		#if tile_data:
			#var can_till = tile_data.get_custom_data(can_till_custom_data)
			#if can_till:
				#background.set_cell(ground_layer, player_tile_pos, source_id, atlas_coord)
