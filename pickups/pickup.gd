extends Node2D
class_name Pickup

var label_ping = 0.01

func _ready() -> void:
	$Label.text = Global.get_key_bind_name("pickup") + " | " + name
	$Label.visible = false

func condition(var body):
	return true

func _process(delta: float) -> void:
	$Label.visible = bool($Label/Timer.get_time_left())
	
func on_pickup(var body):
	if !condition(body):
		return false
	



