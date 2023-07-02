extends Node2D
class_name InventoryEquipmentSlot

#export(NodePath) var inventory_slot
var acceptable_groups = ["inventory_drag_slot"]
export(String) var group
export(String, "brain", "skeleton", "operating_system", "nervous_system", "weapon", "food") var equipment_type
var team

func _ready() -> void:	
	add_to_group(group)
	$Background.texture = load("res://ui/sprites/inventory_" + equipment_type + "_slot.png")
	#print("rect = ", colliding_rect())
	
func colliding_rect():
	var rect: Rect2
	rect.size = $TextureButton.get_rect().size
	rect.position = global_position
	return rect
