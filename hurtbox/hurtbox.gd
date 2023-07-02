class_name HurtBox
extends Area2D
	
func _ready() -> void:
	connect("area_entered", self, "on_area_entered")

func on_area_entered(hitbox: HitBox) -> void:
	if !hitbox:
		return
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		
	if hitbox.owner.is_in_group("projectiles"): 
		hitbox.owner.kill(null)
	
	if owner.get_node("StatusHolder") and Global.statuses.has(hitbox.condition_type):
		owner.get_node("StatusHolder").add_status(hitbox.condition_type)
	
	print("hitbox of " + str(hitbox.owner.name) + " entered " + str(owner.name) + " hurtbox")
