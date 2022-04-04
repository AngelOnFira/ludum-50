extends Control

onready var blackboard = get_node("/root/Blackboard")


var shown = [false, false, false]

func _ready():
	pass # Replace with function body.


func _process(delta):
	if blackboard.game_loop > 0:
		return

	if blackboard.timer < 8 * 1000 and shown[0] == false:
		shown[0] = true
		blackboard.emit_signal(
			"show_story",
			"Thoughts",
			"Scientists warned us about the asteroid for months."
		)

	if blackboard.timer < 6 * 1000 and shown[1] == false:
		shown[1] = true
		blackboard.emit_signal(
			"show_story",
			"Thoughts",
			"I guess these are the final few seconds we have..."
		)
