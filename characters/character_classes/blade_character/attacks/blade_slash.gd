extends Node2D
class_name BladeSlash

#var damage = 5
#var speed = 500
export(float) var life_time = 0.5

func _ready() -> void:
	$Timer.connect("timeout", self, "kill")
	$Timer.start(life_time)

func kill():
	queue_free()

