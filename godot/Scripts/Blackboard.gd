extends Node


var money: int = 0

# Story values
var seconds_per_life: float = 10.0
var laptop_price = 1000

var debug = true

# Time variables
var timer = 1000 * seconds_per_life
var time_multiplier = 1.0

# Story variables
var game_loop = 0
var explore_length = 25
var loot_found = false

# Total time added from things that aren't in the character's memory
var total_added_seconds_ephemeral = 0.0
# var total_remembered_seconds = 0.0

var compendium = []


# If they haven't found the TekShop yet
var tutorial = true

# Survive story
var try_to_survive_story_index = 0
var try_to_survive_story = [
	"Nothing here...",
	"A... rock?",
	"It's the local pizza shop!",
]

func _ready():
	if debug:
		# Enable the debug numbers
		# seconds_per_life = 1
		laptop_price = 10

		# Skip the tutorial
		game_loop = 10

	print(compendium)


func reset_game():
	# Increase the game loop, story elements will depend on this
	game_loop += 1

	try_to_survive_story_index = 0

	# Reset the time
	emit_signal("increase_time")

	timer = 1000 * seconds_per_life

	# Reset money
	if money > 0:
		emit_signal("decrease_money")
	money = 0

	# Reset any non-remembered time
	total_added_seconds_ephemeral = 0.0

	# TODO animate money/time resetting
	emit_signal("reset_timeline")


# Signals

# Reveal a new tab
signal show_tab(tab)

# Show a story message right now
signal show_story(speaker, text)

# Queue a story message to show at the next death
signal queue_story(speaker, text)

signal increase_time()

signal decrease_money()

signal reset_timeline()

signal progress_time(delta)

signal add_money(amount)

signal play_sfx(sound)
# Get the multiplier for time
func update_time_multiplier():
	# Collect times from the compendium
	var compentium_time_added = 0.0

	for entry in compendium:
		if "seconds_added" in entry:
			compentium_time_added += entry["seconds_added"]


	var total_added_time = total_added_seconds_ephemeral + compentium_time_added + seconds_per_life

	# Update the time multiplier
	time_multiplier = seconds_per_life / total_added_time

func add_to_compendium(name: String, seconds_added: float):
	# Make sure the compendium is visible
	emit_signal("show_tab", 2)

	# Add the entry
	var compendium_entry = {
		"name": name,
		"seconds_added": seconds_added,
	}
	compendium.append(compendium_entry)
