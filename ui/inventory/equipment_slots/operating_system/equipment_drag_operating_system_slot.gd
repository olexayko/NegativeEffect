extends "res://ui/inventory/equipment_slots/brain/equipment_drag_brain_slot.gd"


func capture():
	var operating_system = get_node(equipment_slot).inventory.team.chosen_character.operating_system()
	if not operating_system:
		return
	
	$Control/Sprite.texture = operating_system.get_node("Sprite").texture
	
	#print(operating_system)
	print("CAPTURE")
	captured = true
	on_capture()
	content = operating_system
	
	#print("content captured = ", content)
