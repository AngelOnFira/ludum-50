extends Node

### Automatic References Start ###
onready var _money_gain: AudioStreamPlayer = $MoneyGain
### Automatic References Stop ###


onready var blackboard = get_node("/root/Blackboard")


# Called when the node enters the scene tree for the first time.
func _ready():
	blackboard.connect("play_sfx", self, "play_sfx")


func play_sfx(sound: String):
	if sound == "money_gain":
		_money_gain.play()
	else:
		print("Unknown sound: " + sound)
