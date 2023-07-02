extends "res://ui/inventory/equipment_slots/brain/equipment_drag_brain_slot.gd"


func capture():
	var weapon = get_node(equipment_slot).inventory.team.chosen_character.weapon()
	if not weapon:
		return
	
	$Control/Sprite.texture = weapon.get_node("Sprite").texture
	
	#print(weapon)
	print("CAPTURE")
	captured = true
	on_capture()
	content = weapon
	
	#print("content captured = ", content)
