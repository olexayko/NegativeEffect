extends Node
class_name Status

export(float) var life_time = 4.0

func _ready() -> void:
	$Timer.start(life_time)
	$Timer.connect("timeout", self, "die")
	
func _process(delta: float) -> void:
	#print($Timer.get_time_left())
	pass
	
func die():
	queue_free()
