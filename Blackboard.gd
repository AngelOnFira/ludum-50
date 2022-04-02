extends Node


var money: int = 0

var seconds_per_life: float = 10.0

var timer = 1000 * seconds_per_life
var time_multiplier = 1.0

# Total time added from things that aren't in the character's memory
var total_added_seconds_ephemeral = 0.0
var total_remembered_seconds = 0.0


# If they haven't found the TekShop yet
var tutorial = true

# Survive story
var try_to_survive_story_index = 0
var try_to_survive_story = [
	"You look around you, and don't find much of use. Better keep searching!",
	# "You see the mall off in the distance.",
	# "You run down the street.",
	# "You keep running down the street.",
	# "You keep running down the street. (It's getting closer!)",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street. (Just a bit further!)",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street. (You're really close!)",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You keep running down the street.",
	# "You enter the mall.",
	# "You start looking at stores",
	"You find the TekShop!",
]



func reset_game():
	try_to_survive_story_index = 0

	# Reset the time
	timer = 1000 * seconds_per_life

	# Reset money
	money = 0

	# Reset any non-remembered time
	total_added_seconds_ephemeral = 0.0

	# TODO animate money/time resetting


# Signals

# Reveal a new tab
signal show_tab(tab)

# Show a story message right now
signal show_story(text)

# Queue a story message to show at the next death
signal queue_story(text)

# Get the multiplier for time
func update_time_multiplier():
	var total_added_time = total_added_seconds_ephemeral + total_remembered_seconds + seconds_per_life
	# Update the time multiplier
	time_multiplier = 1.0 + seconds_per_life / total_added_time
