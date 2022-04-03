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

onready var tab_container = $MainScreenDivision/LeftSide/LeftSidePanel/TabContainer

# Animations
onready var money_animation_player = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Money/MoneyAnimation
onready var timer_animation_player = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Timer/TimerAnimation
onready var asteroid_animation_player = $MainScreenDivision/RightSide/Asteroid/AsteroidAnimation

onready var timer_node = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Timer
onready var money_node = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Money

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

	# Animations
	blackboard.connect("decrease_money", self, "decrease_money_animation")
	blackboard.connect("increase_time", self, "increase_time_animation")
	blackboard.connect("reset_timeline", self, "reset_timeline_animations")

	blackboard.emit_signal("reset_timeline")
	blackboard.emit_signal("show_story", "Thoughts", "The scientist have watched this asteroid coming towards Earth for MONTHS! I guess these are the final few seconds we have...")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gain = 0
	
	var laptop_per_second_per_level = 0.5
	gain += 0.5 * delta * levels[0]
	
	blackboard.money += gain
	var amount = int(blackboard.money)
	money_node.text = "$" + str(amount)

	
	# Make changes to time
	change_time(delta)

	# If time runs out, reset the timer to 10 seconds
	if blackboard.timer <= 0:

		print(story_queue)
		
		# Run the reset function in blackboard
		blackboard.reset_game()

		# If there are story elements in the queue, show them first
		if len(story_queue) > 0:
			var story_element = story_queue.pop_front()
			blackboard.emit_signal("show_story", "???", story_element)
		
		# Otherwise, just show the next story element
		elif blackboard.tutorial:
			# Show story if there is anything new
			blackboard.emit_signal("show_story", "???", story[story_index])

			if story_index < len(story) - 1:
				story_index += 1

		timer_node.text = "00:000"

# Make the calculations of how the timer should change
func change_time(delta):
	var real_time_change: float = 1000 * delta

	# Change based on the multiplier
	blackboard.update_time_multiplier()
	var multiplier_adjust: float = real_time_change * blackboard.time_multiplier

	# Subtract time
	blackboard.timer -= multiplier_adjust

	var seconds = int(blackboard.timer / 1000)
	var milliseconds = int(int(blackboard.timer) % 1000)

	# Create time label
	var time_left = "%0*d:%0*d" % [
		2,
		seconds,
		3,
		milliseconds,
	]
	
	timer_node.text = time_left

func _on_Button_pressed():
	levels[0] += 1


func _on_Continue_pressed():
	# Hide the panel
	$StoryPanel.visible = false

	# Start the game again
	get_tree().paused = false

	timer_node.text = "10:000"



func show_tab(tab: int):
	tab_container.set_tab_hidden(tab, false)


func show_story(speaker: String, story_text: String):
	var speaker_coloured = ""

	if speaker == "Thoughts":
		speaker_coloured = "[color=blue]%s[/color]" % speaker
	elif speaker == "???":
		speaker_coloured = "[color=red]%s[/color]" % speaker
	else:
		speaker_coloured = "[color=green]%s[/color]" % speaker

	# Change the text
	$StoryPanel/RichTextLabel.bbcode_text = speaker_coloured + ":\n" + story_text

	# Show the StoryPanel
	$StoryPanel.visible = true

	# Pause the game
	get_tree().paused = true

func queue_story(story_text: String):
	# Add the story to the queue
	story_queue.append(story_text)

func decrease_money_animation():
	money_animation_player.play("DecreaseMoney")

func increase_time_animation():
	timer_animation_player.play("IncreaseTime")

func reset_timeline_animations():
	asteroid_animation_player.play("MoveAsteroid", -1, 1.0, false)
