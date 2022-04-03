extends Control

### Automatic References Start ###
onready var _name: Label = $HBoxContainer/Name
onready var _progress_bar: ProgressBar = $HBoxContainer/ProgressBar
### Automatic References Stop ###

onready var blackboard = get_node("/root/Blackboard")


var system_name = "Computer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func change_name(new_name: String):
	self.system_name = new_name
	_name.text = new_name

	blackboard.connect("progress_time", self, "progress_time")

func progress_time(delta: float):
	_progress_bar.progress += delta