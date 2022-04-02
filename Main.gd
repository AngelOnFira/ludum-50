extends Control

onready var blackboard = get_node("/root/Blackboard")



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Design
# 
# Starting
# - Run and hide
# - Scream and watch the asteroid
# 
# Mid
# - Buy laptop
# - Get first few currencies
# - 
# 

var story_index = 0
var story = [
	"Hmm, it seems that the world has ended. How about we give it another try?",
	"It ended again? Well, I guess we'll have to start over.",
	"Ok, let's try again. I'll give you a hint: the world is ending.",
	"I'm sure you'll be able to figure it out. That last hint wasn't super helpful. Aren't you trying to find a way to survive?",
]

var story_queue = []

var levels = [
	0, # Laptop updates
]

onready var tab_container = $LeftSide/LeftSidePanel/TabContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$StoryPanel/RichTextLabel.text = story[0]
	
	# Hide any tabs except the first
	for i in range(1, tab_container.get_child_count()):
		tab_container.set_tab_hidden(i, true)

	# Attach signals
	blackboard.connect("show_tab", self, "show_tab")
	blackboard.connect("show_story", self, "show_story")
	blackboard.connect("queue_story", self, "queue_story")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gain = 0
	
	var laptop_per_second_per_level = 0.5
	gain += 0.5 * delta * levels[0]
	
	blackboard.money += gain
	var amount = int(blackboard.money)
	

	# Subtract time
	blackboard.timer -= 1000 * delta

	var seconds = int(blackboard.timer / 1000)
	var milliseconds = int(int(blackboard.timer) % 1000)

	# Create time label
	var time_left = "%0*d:%0*d" % [
		2,
		seconds,
		3,
		milliseconds,
	]
	
	$LeftSide/LeftSidePanel/CurrencyBox/Timer.text = time_left
	$LeftSide/LeftSidePanel/CurrencyBox/Money.text = "$" + str(amount)

	# If time runs out, reset the timer to 10 seconds
	if blackboard.timer <= 0:

		print(story_queue)
		
		# Run the reset function in blackboard
		blackboard.reset_game()

		# If there are story elements in the queue, show them first
		if len(story_queue) > 0:
			var story_element = story_queue.pop_front()
			blackboard.emit_signal("show_story", story_element)
		
		# Otherwise, just show the next story element
		elif blackboard.tutorial:
			# Show story if there is anything new
			if story_index < len(story):
				blackboard.emit_signal("show_story", story[story_index])
				story_index += 1

		$LeftSide/LeftSidePanel/CurrencyBox/Timer.text = "00:000"
		


func _on_Button_pressed():
	levels[0] += 1


func _on_Continue_pressed():
	# Hide the panel
	$StoryPanel.visible = false

	# Start the game again
	get_tree().paused = false

	$LeftSide/LeftSidePanel/CurrencyBox/Timer.text = "10:000"



func show_tab(tab: int):
	tab_container.set_tab_hidden(tab, false)


func show_story(story_text: String):
	# Change the text
	$StoryPanel/RichTextLabel.text = story_text

	# Show the StoryPanel
	$StoryPanel.visible = true

	# Pause the game
	get_tree().paused = true

func queue_story(story_text: String):
	print("Queueing story: " + story_text)
	# Add the story to the queue
	story_queue.append(story_text)
