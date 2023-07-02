extends Node2D
#export(NodePath) var inventory_slot

var acceptable_groups = ["inventory_drag_slot"]

func _ready() -> void:	
	add_to_group("inventory_drop_slot")
	#print("rect = ", colliding_rect())
	
func colliding_rect():
	var rect: Rect2
	rect.size = $Control.get_rect().size
	rect.position = global_position
	return rect

