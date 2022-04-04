extends Control

### Automatic References Start ###
onready var _name: Label = $HBoxContainer/Name
onready var _progress_bar: ProgressBar = $HBoxContainer/ProgressBar
### Automatic References Stop ###

onready var blackboard = get_node("/root/Blackboard")

var total_time_needed: float = 5.0
var system_name = "Computer"

# Called when the node enters the scene tree for the first time.
func _ready():
	_progress_bar.value = 0


func change_name(new_name: String):
	self.system_name = new_name
	_name.text = new_name

	blackboard.connect("progress_time", self, "progress_time")

func progress_time(delta: float):
	var percent_passed = delta / total_time_needed * 100
	_progress_bar.value += percent_passed

func _process(delta):
	progress_time(delta)
