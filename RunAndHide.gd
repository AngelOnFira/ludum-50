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

var try_to_survive_story_index = 0
var try_to_survive_story = [
	"You look around you, and don't find much of use. Better keep searching!",
	"You see the mall off in the distance.",
	"You run down the street.",
	"You keep running down the street.",
	"You keep running down the street. (It's getting closer!)",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street. (Just a bit further!)",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street. (You're really close!)",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You keep running down the street.",
	"You enter the mall.",
	"You start looking"
	""
	"You find the TekShop!"
]

func _on_Hide_pressed(extra_arg_0:int):
	# Add a random amount of money
	blackboard.money += randi() % 40 + 10

	# Add the log entry
	log_text.insert(0, hide_story[extra_arg_0 - 1])

	# If they pondered, add the survive button
	if extra_arg_0 == 3:
		$HBoxContainer/LeftPanel/Search1.visible = true

	# Update the text log
	var log_text_string = ""
	for i in range(len(log_text)):
		log_text_string += log_text[i] + "\n\n"

	log_node.text = log_text_string
