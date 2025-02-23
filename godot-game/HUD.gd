extends Node2D

var day = 0
var char_name = "Tia"
var nameId = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Timer.start()
	get_node("./game_over").hide()
	hide_fishing_tooltip()
	hide_fishing_bar()

func update_score(score):
	#$Time.text = str(score)
	pass

#Fishing tooltip
func hide_fishing_tooltip() -> void:
	get_node("./fishing_label").hide()

func show_fishing_tooltip() -> void:
	get_node("./fishing_label").show()

#Fishing progress bar
func hide_fishing_bar() -> void:
	get_node("./fishing_bar").hide()

func show_fishing_bar() -> void:
	get_node("./fishing_bar").show()
	
#Gameover
func game_over() -> void:
	get_node("./game_over").show()
	#await get_tree().create_timer(1.0).timeout
	get_tree().paused = true

func fish() ->void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#update_score("Day: " + str(day) + " Time: " + str(snapped($Timer.get_time_left(), 0.001)))
	#_input(delta)
	pass

#func _on_timer_timeout():
	#day += 1
	#pass

func _input(event):
	#if day >= 100:
		#$Finish.show()
		#if Input.is_action_pressed("ui_cancel"):
			#get_tree().quit()
	#else:
		#$Finish.hide()
	pass

func get_char_name():
	return char_name

func _on_name_2_pressed():
	if (nameId == 0):
		char_name = "Timmy"
		nameId = 1
	else:
		char_name = "Tia"
		nameId = 0
	#get_tree().call_group("HUD", "set_new_name", char_name)
