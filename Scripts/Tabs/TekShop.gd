extends Tabs

### Automatic References Start ###
onready var _home_lab: Control = $HBoxContainer/VBoxContainer/HomeLab
### Automatic References Stop ###

onready var blackboard = get_node("/root/Blackboard")
onready var system = preload("res://Scenes/System.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# If the buy laptop button is pressed
func _on_Laptop_pressed():
	# Make sure they have enough money
	if blackboard.money > blackboard.laptop_price:
		# Take the money
		blackboard.money -= blackboard.laptop_price

		# Send a message about the laptop
		blackboard.emit_signal("show_story", "???", "You bought a laptop I see. What are you looking up? Medetation techniques? Do you really think you can slow down time enough to matter?")

		# Add the entry to the compendium
		blackboard.add_to_compendium(
			"Medetation techniques",
			5.0
		)

		# Add a laptop to the homelab
		var new_system = system.instance()
		_home_lab.add_child(new_system)

		new_system.total_time_needed = 1.0