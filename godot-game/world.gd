extends Node2D

# extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
var can_fertilize_custom_data = "can_fertilize"
var can_seed_corn_custom_data = "can_seed_corn"
var can_seed_carrot_custom_data = "can_seed_carrot"
var can_seed_turnip_custom_data = "can_seed_turnip"
var can_seed_strawberry_custom_data = "can_seed_strawberry"
var can_seed_cabbage_custom_data = "can_seed_cabbage"
var can_water_corn_custom_data = "can_water_corn"
var can_water_carrot_custom_data = "can_water_carrot"
var can_water_turnip_custom_data = "can_water_turnip"
var can_water_strawberry_custom_data = "can_water_strawberry"
var can_water_cabbage_custom_data = "can_water_cabbage"
var can_harvest_corn_custom_data = "can_harvest_corn"
var can_harvest_carrot_custom_data = "can_harvest_carrot"
var can_harvest_turnip_custom_data = "can_harvest_turnip"
var can_harvest_cabbage_custom_data = "can_harvest_cabbage"
var can_harvest_strawberry_custom_data = "can_harvest_strawberry"



func time():
	if ($Timer.get_time_left() < 10.5):
		$background.set_layer_enabled(1, true)
	else:
		$background.set_layer_enabled(1, false)



func _input(event):
	player_tile_pos = background.local_to_map(background.to_local($player.position))
	
	var tile_data : TileData = background.get_cell_tile_data(ground_layer, player_tile_pos)
	var source_id = 0
	var atlas_coord = Vector2i(0,0)
	
	var enable = get_tree().create_timer(.9)
	
	var loop_number = 1
	

	
	if Input.is_action_just_pressed("till"):
		
		tile_data = background.get_cell_tile_data(ground_layer, player_tile_pos)
		source_id = 0
		atlas_coord = Vector2i(4,7)
		
		if tile_data:
			var can_till = tile_data.get_custom_data(can_till_custom_data)
			if can_till:
				background.set_cell(ground_layer, player_tile_pos, source_id, atlas_coord)
	
	if Input.is_action_just_pressed("plant_corn"):
		tile_data = background.get_cell_tile_data(ground_layer, player_tile_pos)
		source_id = 0
		atlas_coord = Vector2i(8, 7)
			
		if tile_data:
			var can_seed_corn = tile_data.get_custom_data(can_seed_corn_custom_data)
			if can_seed_corn:
				get_tree().call_group("HUD", "subtract_item", 1)
				background.set_cell(ground_layer, player_tile_pos, source_id, atlas_coord)
