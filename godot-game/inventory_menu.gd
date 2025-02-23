extends Panel

var fishCount = 0
var clownfishCount = 0
var sharkCount = 0

@onready var fish_label: Label = $fish_tbutton/fcount_label
@onready var clownfish_label: Label = $clownfish_tbutton/ccount_label
@onready var shark_label: Label = $shark_tbutton/scount_label
@onready var hunger_bar_node = get_node("/root/Game/player/Hud/hunger_bar")



# Called when the panel is ready
func _ready():
	# Initialize any necessary components or data here
	hide()  # Ensure the menu is hidden at the start
	update_labels()


# Function to show the inventory menu
func show_inventory():
	self.show()
	update_labels()

# Function to hide the inventory menu
func hide_inventory():
	self.hide()
	
func eatFish():
	if (fishCount>0):
		fishCount-=1
	hunger_bar_node.replenish_health(5)
	update_labels()

func catchFish():
	fishCount+=1
	update_labels()

func eatClownfish():
	if (clownfishCount>0):
		clownfishCount-=1
	hunger_bar_node.replenish_health(10)
	update_labels()

func catchClownFish():
	clownfishCount+=1
	update_labels()
	
func eatShark():
	if (sharkCount>0):
		sharkCount-=1
	hunger_bar_node.replenish_health(20)
	update_labels()
	
func catchShark():
	sharkCount+=1
	update_labels()

func update_labels():
	fish_label.text =  str(fishCount)
	clownfish_label.text =  str(clownfishCount)
	shark_label.text =  str(sharkCount)
