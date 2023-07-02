extends Node
class_name Enemy

export(float) var hp 
export(float) var damage 

func _ready():
	pass

func take_damage(var dmg):
	hp -= dmg
	$Label.text = str(hp)
	if hp <= 0:
		die()

func die():
	queue_free()
