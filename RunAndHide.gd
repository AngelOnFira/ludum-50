extends Tabs

onready var blackboard = get_node("/root/Blackboard")


var log_text = []
onready var log_node = $HBoxContainer/LogBG/HideLog

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

var hide_story = [
	"You hide under a tree, and find a dropped wallet!",
	"As you scream, money falls from the sky!",
	"As you think, you decide that you should try to survive. Well done, you have earned some money!"
]

func update_log():
	# Update the text log
	var log_text_string = ""
	for i in range(len(log_text)):
		log_text_string += log_text[i] + "\n\n"

	log_node.text = log_text_string
	

func _on_Hide_pressed(extra_arg_0:int):
	# Add a random amount of money
	blackboard.money += randi() % 40 + 10

	# Add the log entry
	log_text.insert(0, hide_story[extra_arg_0 - 1])

	# If they pondered, add the survive button
	if extra_arg_0 == 3:
		$HBoxContainer/LeftPanel/Search1.visible = true

	# Update the log
	update_log()

func _on_Search_pressed():
	log_text.insert(0, survive_story())

	# Update the log
	update_log()

func survive_story():
	var story = ""

	# Check if we're at the end
	if blackboard.try_to_survive_story_index >= len(blackboard.try_to_survive_story):
		# They survived!
		story = "You've already found the TekShop!"
	else:
		# Add the current survive story to the log
		story = blackboard.try_to_survive_story[blackboard.try_to_survive_story_index]

	# If we're right at the end
	if blackboard.try_to_survive_story_index == len(blackboard.try_to_survive_story):
		# Show the TekShop tab
		blackboard.emit_signal("show_tab", 1)

	
	# Increment the story index
	blackboard.try_to_survive_story_index += 1

	return story
