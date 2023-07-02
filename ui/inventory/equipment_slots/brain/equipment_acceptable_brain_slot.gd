extends Node2D
export(NodePath) var equipment_slot

var acceptable_groups = ["inventory_drag_slot"]
var active = true

func _ready() -> void:	
	add_to_group("equipment_accept_slot")
	#print("rect = ", colliding_rect())
	
func colliding_rect():
	var rect: Rect2
	rect.size = $Control.get_rect().size
	rect.position = global_position
	return rect
