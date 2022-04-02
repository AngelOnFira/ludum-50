extends Tabs

onready var blackboard = get_node("/root/Blackboard")


var log_text = []
onready var log_node = $HBoxContainer/HideLog

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_Hide_pressed(extra_arg_0:int):
	# Add a random amount of money
	blackboard.money += randi() % 40 + 10

	# Add the log entry
	if extra_arg_0 == 1:
		log_text.insert(0, "Hide pressed")

	# Update the text log
	var log_text_string = ""
	for i in range(len(log_text)):
		log_text_string += log_text[i] + "\n"

	log_node.text = log_text_string
