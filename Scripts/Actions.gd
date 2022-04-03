extends Tabs

### Automatic References Start ###
onready var _explore: Button = $HBoxContainer/LeftPanel/Explore
onready var _hide_log: RichTextLabel = $HBoxContainer/VBoxContainer/LogBG/HideLog
onready var _loot: Button = $HBoxContainer/LeftPanel/Loot
### Automatic References Stop ###

onready var blackboard = get_node("/root/Blackboard")


var log_text = []

# Clicking docs
# Source https://clickspeedtest.com/
#
# Fastest one finger 7.2
# Fastest two fingers 12
# Realistic one finger 5.6
# Slow one finger 3.8

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	if blackboard.debug:
		# Show the buttons
		_explore.visible = true

	# Set up the log
	log_text = []
	update_log()

	blackboard.connect("reset_timeline", self, "reset_timeline")

var hide_story = [
	"You hide under a tree, and find a dropped wallet!",
	"As you scream, money falls from the sky!",
	"As you think, you decide that you should try to survive."
]

func update_log():
	# Update the text log
	var log_text_string = ""
	for i in range(len(log_text)):
		log_text_string += log_text[i] + "\n\n"

	_hide_log.text = log_text_string
	

func _on_Search_pressed():
	insert_log(survive_story())

# Explore button
func survive_story():
	var story = ""

	# Chance to discover looting
	if randi() % 100 < 20 and blackboard.loot_found == false:
		blackboard.loot_found = true
		story += "You find a wallet on the ground!"
		blackboard.emit_signal("show_story", "Thoughts", "Ooh, a wallet! I guess there's a lot around that I can loot now that I know where to look :)")

		# Make loot visible
		_loot.visible = true

		# Call the loot function
		_on_Loot_pressed()
		
	else:
		# Check if we're at the end
		if blackboard.try_to_survive_story_index >= blackboard.explore_length:
			pass
		else:
			# Add the current survive story to the log
			var story_progress = blackboard.try_to_survive_story_index
			var story_list = blackboard.try_to_survive_story
			var story_string = story_list[randi() % story_list.size()]

			story = "(" + str(story_progress) + "/" + str(blackboard.explore_length) + ") " + story_string

		# If we're right at the end
		if blackboard.try_to_survive_story_index == blackboard.explore_length:
			# Show the TekShop tab
			blackboard.emit_signal("show_tab", 1)

			# Disable the explore button
			_explore.disabled = true

			# End the tutorial
			blackboard.tutorial = false

			# Send a message to the player
			blackboard.emit_signal("show_story", "???", "You found... the TekShop? Why are you so excited about that? What will it help you acheive? You'll probably just die again.")
			blackboard.emit_signal("queue_story", "???", "Oh... I guess you'll remember that the TekShop exists. Hmm. This might be a problem.")

	
	# Increment the story index
	blackboard.try_to_survive_story_index += 1

	return story

func reset_timeline():
	# Reset the log
	log_text = []
	update_log()

func insert_log(text: String):
	log_text.insert(0, text)

	if len(log_text) > 5:
		log_text.pop_back()

	# Update the log
	update_log()


func _on_Scream_pressed():
	var scream_lines = [
		"AHHHHHH",
		"GAAHHHH",
		"AAAAHHHHH",
		"PLEASE NOOOOO",
		"WHYYYYY",
	]
	insert_log(scream_lines[randi() % scream_lines.size()])


func _on_Loot_pressed():
	# Add a random amount of money
	var money_found = randi() % 40 + 10
	blackboard.money += money_found

	blackboard.emit_signal("add_money", money_found)

	var money_found_string = "Ooh, loot! +$" + str(money_found) + ""

	# Add the log entry
	insert_log(money_found_string)
