extends Tabs

onready var blackboard = get_node("/root/Blackboard")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Laptop_pressed():
	# Make sure they have enough money
	if blackboard.money > 1000:
		# Take the money
		blackboard.money -= 1000

		# Send a message about the laptop
		blackboard.emit_signal("show_story", "You bought a laptop I see. What are you looking up? Medetation techniques? Do you really think you can slow down time enough to matter?")

		# Slow down time
		blackboard.total_remembered_seconds += 5.0