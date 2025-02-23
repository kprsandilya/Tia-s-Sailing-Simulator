extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_tooltip()

func hide_tooltip() -> void:
	get_node("./fishing_spot_area/fishing_label").hide()

func show_tooltip() -> void:
	get_node("./fishing_spot_area/fishing_label").show()

func fish() ->void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
