extends Node2D

#var damage = 5
#var speed = 500
var live_time = 0.5
var direction = Vector2(1, 0)

func _ready() -> void:
	$Timer.connect("timeout", self, "kill")
	$Timer.start(live_time)

func kill():
	queue_free()
