extends Tabs

onready var blackboard = get_node("/root/Blackboard")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var test: NodePath



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Update the compendium text
	var compendium_text = ""

	for entry in blackboard.compendium:
		compendium_text += entry["name"] + ": "
		
		if "seconds_added" in entry:
			compendium_text += "+" + str(entry["seconds_added"]) + "s "

		compendium_text += "\n"

	$HBoxContainer/LogBG/CompendiumText.text = compendium_text
