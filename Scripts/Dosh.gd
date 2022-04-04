extends Node2D

### Automatic References Start ###
onready var _dosh_animator: AnimationPlayer = $AnimationShift/DoshAnimator
onready var _label: Label = $AnimationShift/Label
### Automatic References Stop ###



var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_label.text = "+$" + str(amount)

	_dosh_animator.play("CacheMoney")

	yield(_dosh_animator, "animation_finished")

	# Kill this node
	get_parent().remove_child(self)
