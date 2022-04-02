extends Control


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

var story = [
	"Hmm, it seems that the world has ended. How about we give it another try?",
]

var timer = 1000 * 1 # 10 seconds

var money: float = 0.0

var levels = [
	0, # Laptop updates
]


# Called when the node enters the scene tree for the first time.
func _ready():
	$StoryPanel/RichTextLabel.text = story[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gain = 0
	
	var laptop_per_second_per_level = 0.5
	gain += 0.5 * delta * levels[0]
	
	money += gain
	
	var amount = int(money)

	# Subtract time
	timer -= 1000 * delta

	var seconds = int(timer / 1000)
	var milliseconds = int(int(timer) % 1000)

	# Create time label
	var time_left = "%0*d:%0*d" % [
		2,
		seconds,
		3,
		milliseconds,
	]
	
	$LeftSide/LeftSidePanel/Timer.text = time_left
	# $"LeftSide/LeftSidePanel/TabContainer/Run and hide!/LeftPanel/Money".text = str(amount)

	# If time runs out, reset the timer to 10 seconds
	if timer <= 0:
		timer = 1000 * 10
		$LeftSide/LeftSidePanel/Timer.text = "10:0000"
		# $"LeftSide/LeftSidePanel/TabContainer/Run and hide!/LeftPanel/Money".text = "0"

		# Show the StoryPanel
		$StoryPanel.visible = true

		# Pause the game
		get_tree().paused = true



func _on_Button_pressed():
	levels[0] += 1


func _on_Continue_pressed():
	# Hide the panel
	$StoryPanel.visible = false

	# Start the game again
	get_tree().paused = false

	print("resumed~!")


