extends ProgressBar
@export var decrease_amount: float = 5.0  # Percentage decrease
@export var interval: float = 10.0  # Time in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Cafunc _ready():
	start_health_decrease()

func start_health_decrease():
	var timer = Timer.new()
	timer.wait_time = interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	value -= (max_value * decrease_amount / 100.0)
	value = max(value, min_value)  # Prevent negative values
