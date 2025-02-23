extends ProgressBar
@export var decrease_amount: float = 10  # Percentage decrease
@export var interval: float = 10.0  # Time in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Cafunc _ready():
	value = 100
	start_health_decrease()

func start_health_decrease():
	var timer = Timer.new()
	timer.wait_time = interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func replenish_health(food_value):
	value += food_value

func _on_timer_timeout():
	value -= (max_value * decrease_amount / 100.0)
	value = max(value, min_value)  # Clamping
	if value == 0:
		get_node("/root/Game/player/Hud").game_over()
