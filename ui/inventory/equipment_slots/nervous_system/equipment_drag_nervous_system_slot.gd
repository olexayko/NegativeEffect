extends "res://ui/inventory/equipment_slots/brain/equipment_drag_brain_slot.gd"


func capture():
	var nervous_system = get_node(equipment_slot).inventory.team.chosen_character.nervous_system()
	if not nervous_system:
		return
	
	$Control/Sprite.texture = nervous_system.get_node("Sprite").texture
	
	#print(nervous_system)
	print("CAPTURE")
	captured = true
	on_capture()
	content = nervous_system
	
	#print("content captured = ", content)
