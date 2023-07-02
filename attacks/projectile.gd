extends RigidBody2D
class_name Projectile

export(float) var damage

export(int) var speed = 500
export(float) var live_time = 0.25
export(bool) var dies_with_time = false

func _ready() -> void:
	add_to_group("projectiles")
	$HitBox.damage = damage
	if dies_with_time:
		get_node("LifeTimeLeft").connect("timeout", self, "kill_1")
		get_node("LifeTimeLeft").start(live_time)
	connect("body_entered", self, "kill")

func kill(body):
	queue_free()
	
func kill_1():
	queue_free()

