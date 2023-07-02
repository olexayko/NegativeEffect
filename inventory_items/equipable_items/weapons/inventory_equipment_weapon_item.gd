extends InventoryEquipmentItem
class_name InventoryEquipmentWeaponItem
export(String, "Blunt", "Blade", "OneHanded", "Rifle", "Shotgun", "Pistol") var equipment_type

func equip():
	var team = item_list.team	
	print("team.chosen_character.attack_type = ", team.chosen_character.attack_type)
	print("equipment_type = ", equipment_type)
	
	if team.chosen_character.attack_type == equipment_type:
		if !team.chosen_character.get_node("ProjectileSpawn/Weapon").get_child_count():
			var e = load(equipment).instance()
			e.team = item_list.team
			team.chosen_character.get_node("ProjectileSpawn/Weapon").add_child(e)
			queue_free()	
