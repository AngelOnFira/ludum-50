extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Design
# 
# Starting
# - Buy laptop
# - Get first few currencies
# 
# Mid
# 

var money: float = 0.0

var levels = [
	0, # Laptop updates
]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gain = 0
	
	var laptop_per_second_per_level = 0.5
	gain += 0.5 * delta * levels[0]
	
	money += gain
	
	var amount = int(money)
	
	
	$HBoxContainer/LeftPanel/Money.text = str(amount)


func _on_Button_pressed():
	levels[0] += 1
