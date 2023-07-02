extends Node2D
class_name Effect

export (float) var life_time
export (float) var damage

func _ready() -> void:
	$HitBox.damage = damage
	#get_node()
	$LifeTimeLeft.start(life_time)
	$LifeTimeLeft.connect("timeout", self, "die")

func die():
	queue_free()
