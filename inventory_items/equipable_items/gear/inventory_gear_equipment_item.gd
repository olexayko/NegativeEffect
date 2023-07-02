extends InventoryEquipmentItem
class_name InventoryGearEquipmentItem
export(String, "Brain", "Skeleton", "OperatingSystem", "NervousSystem") var equipment_type

func equip():
	var team = item_list.team	
	if !team.chosen_character.get_node("Equipment/" + str(equipment_type)).get_child_count():
		#print("load(equipment) = ", equipment)
		var e = load(equipment).instance()
		e.team = item_list.team
		team.chosen_character.get_node("Equipment/" + str(equipment_type)).add_child(e)
		queue_free()
