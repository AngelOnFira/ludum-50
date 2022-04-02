extends Node


var money: int = 0

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


# Signals
signal show_tab(tab)