extends Node2D

# extends Node

@onready var fishing_spot_scene = preload("res://fishing_spot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		spawn_fish()

func spawn_fish():
	print("Spawned Fish")
	var new_object = fishing_spot_scene.instantiate()
	new_object.position = Vector2(randi_range(-131, 124), randi_range(-83, 76))
	new_object.z_index = 0
	add_child(new_object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#_input(delta)


#@onready var background = $background

#var ground_layer = 0

#@onready var player_tile_pos : Vector2i = background.local_to_map($player.position)
