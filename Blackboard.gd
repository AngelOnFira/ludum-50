extends Node


var money: int = 0

var seconds_per_life: int = 2

var timer = 1000 * seconds_per_life

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

	# TODO animate money/time resetting


# Signals

# Reveal a new tab
signal show_tab(tab)

# Show a story message right now
signal show_story(text)

# Queue a story message to show at the next death
signal queue_story(text)