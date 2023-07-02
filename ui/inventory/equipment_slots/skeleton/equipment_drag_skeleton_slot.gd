extends "res://ui/inventory/equipment_slots/brain/equipment_drag_brain_slot.gd"


func capture():
	var skeleton = get_node(equipment_slot).inventory.team.chosen_character.skeleton()
	if not skeleton:
		return
	
	$Control/Sprite.texture = skeleton.get_node("Sprite").texture
	
	#print(skeleton)
	print("CAPTURE")
	captured = true
	on_capture()
	content = skeleton
	
	#print("content captured = ", content)
