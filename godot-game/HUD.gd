extends CanvasLayer

var day = 0
var char_name = "Tia"
var nameId = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

func update_score(score):
	$Time.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_score("Day: " + str(day) + " Time: " + str(snapped($Timer.get_time_left(), 0.001)))
	_input(delta)

func _on_timer_timeout():
	day += 1

func _input(event):
	if day >= 100:
		$Finish.show()
		if Input.is_action_pressed("ui_cancel"):
			get_tree().quit()
	else:
		$Finish.hide()

func get_char_name():
	return char_name

func _on_name_2_pressed():
	if (nameId == 0):
		char_name = "Timmy"
		nameId = 1
	else:
		char_name = "Tia"
		nameId = 0
	get_tree().call_group("HUD", "set_new_name", char_name)
