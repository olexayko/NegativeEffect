extends Node2D
class_name BluntSlash

#var damage = 5
#var speed = 500
export(float) var life_time = 0.5

func _ready() -> void:
	$AnimationPlayer.advance(0)
	$Timer.connect("timeout", self, "kill")
	$Timer.start(life_time)

func kill():
	queue_free()

