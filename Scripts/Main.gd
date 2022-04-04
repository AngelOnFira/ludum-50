extends Control

### Automatic References Start ###
onready var _explore: Button = $MainScreenDivision/LeftSide/LeftSidePanel/TabContainer/Actions/HBoxContainer/LeftPanel/Explore
onready var _game_cover: ColorRect = $AboveAll/ScreenSize/GameCover
onready var _game_cover_animation: AnimationPlayer = $AboveAll/ScreenSize/GameCover/GameCoverAnimation
onready var _grey_out_screen: ColorRect = $AboveAll/ScreenSize/GreyOutScreen
onready var _hide_log: RichTextLabel = $MainScreenDivision/LeftSide/LeftSidePanel/TabContainer/Actions/HBoxContainer/VBoxContainer/LogBG/HideLog
onready var _money: Label = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Money
onready var _money_animation: AnimationPlayer = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Money/MoneyAnimation
onready var _money_increase: Control = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Money/MoneyIncrease
onready var _story_label: RichTextLabel = $AboveAll/ScreenSize/GreyOutScreen/StoryPanel/StoryLabel
onready var _tab_container: TabContainer = $MainScreenDivision/LeftSide/LeftSidePanel/TabContainer
onready var _timer: Label = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Timer
onready var _timer_animation: AnimationPlayer = $MainScreenDivision/LeftSide/LeftSidePanel/CurrencyBox/Timer/TimerAnimation
### Automatic References Stop ###

onready var blackboard = get_node("/root/Blackboard")

onready var dosh = preload("res://Scenes/Dosh.tscn")


onready var asteroid_animation_player = $MainScreenDivision/RightSide/Asteroid/AsteroidAnimation


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

# Track if we need to reset the world after a continue
var world_just_ended = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_story_label.text = story[0]
	
	# Hide any tabs except the first
	if not blackboard.debug:
		for i in range(1, _tab_container.get_child_count()):
			_tab_container.set_tab_hidden(i, true)

		


	# Attach signals
	blackboard.connect("show_tab", self, "show_tab")
	blackboard.connect("show_story", self, "show_story")
	blackboard.connect("queue_story", self, "queue_story")

	# Animations
	blackboard.connect("decrease_money", self, "decrease_money_animation")
	blackboard.connect("increase_time", self, "increase_time_animation")
	blackboard.connect("reset_timeline", self, "reset_timeline_animations")

	# Labels
	blackboard.connect("add_money", self, "add_money")

	blackboard.emit_signal("reset_timeline")
	blackboard.emit_signal("show_story", "Thoughts", "Today is the last day.")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If the world just ended, don't process
	if world_just_ended:
		return

	var gain = 0
	
	var laptop_per_second_per_level = 0.5
	gain += 0.5 * delta * levels[0]
	
	blackboard.money += gain
	var amount = int(blackboard.money)
	_money.text = "$" + str(amount)

	
	# Make changes to time
	change_time(delta)

	# If time runs out, reset the timer to 10 seconds
	if blackboard.timer <= 0 and not world_just_ended:
		# Queue world ended
		world_just_ended = true
		get_tree().paused = true

		blackboard.timer = 0
		_timer.text = "00:000"

		# Play the white screen animation
		_game_cover_animation.play("EndWorld")

		# Wait for the animation to finish
		yield(_game_cover_animation, "animation_finished")

		world_ended()


func world_ended():
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

	# Otherwise, show a default message
	else:
		blackboard.emit_signal("show_story", "???", "The world has ended. Hope you don't care about the progress you lost >:)")


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
	
	_timer.text = time_left

	
	# Change the asteroid animation based on the time
	var progress = 10 - (blackboard.timer / 100 / blackboard.seconds_per_life)
	asteroid_animation_player.seek(progress, true)

func _on_Button_pressed():
	levels[0] += 1


func _on_Continue_pressed():
	# Hide the panel
	_grey_out_screen.visible = false

	
	_timer.text = "10:000"
	
	# If the world just ended
	if world_just_ended:
		_game_cover_animation.play_backwards("EndWorld")

		yield(_game_cover_animation, "animation_finished")
		
		# Run the reset function in blackboard
		blackboard.reset_game()
		
		world_just_ended = false

		check_shows()
		
	# Start the game again
	get_tree().paused = false
	



func show_tab(tab: int):
	var current_tab = _tab_container.current_tab
	_tab_container.set_tab_hidden(tab, false)
	_tab_container.current_tab = current_tab


func show_story(speaker: String, story_text: String):
	var speaker_coloured = ""

	if speaker == "Thoughts":
		speaker_coloured = "[color=blue]%s[/color]" % speaker
	elif speaker == "???":
		speaker_coloured = "[color=red]%s[/color]" % speaker
	else:
		speaker_coloured = "[color=green]%s[/color]" % speaker

	# Change the text
	_story_label.bbcode_text = speaker_coloured + ":\n" + story_text

	# Show the StoryPanel
	_grey_out_screen.visible = true

	# Pause the game
	get_tree().paused = true

func queue_story(story_text: String):
	# Add the story to the queue
	story_queue.append(story_text)

func decrease_money_animation():
	_money_animation.play("DecreaseMoney")

func increase_time_animation():
	_timer_animation.play("IncreaseTime")

func reset_timeline_animations():
	asteroid_animation_player.play("MoveAsteroid", -1, 1.0, false)
	asteroid_animation_player.seek(0.0, true)

# See if there is anything else we should reveal to the player
func check_shows():
	# If the stage is...
	if blackboard.game_loop == 1:
		_explore.visible = true

func add_money(amount: int):
	var new_dosh = dosh.instance()
	new_dosh.amount = amount

	# Move a bit randomly
	new_dosh.translate(Vector2(
		randi() % 100 - 50,
		0
	))
	_money_increase.add_child(new_dosh)

	blackboard.money += amount
	_money.text = "$" + str(blackboard.money)


func _on_TabContainer_tab_changed(tab:int):
	print("changingin to ", tab)
