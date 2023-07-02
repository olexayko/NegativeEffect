extends Node2D
var team: Team
var selected_item
var is_opened = false

func _ready() -> void:
	$Rect/ItemList.inventory_ui = self
	team = owner.owner
	yield(team, "ready")
	team.chosen_character = team.get_active_character()
	$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot.inventory = self
	$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot.inventory = self
	$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot.inventory = self
	$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot.inventory = self
	$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot.inventory = self
	$ActiveCharacter/TabContainer/Equipment/EquipmentFoodSlot.inventory = self
	#$ActiveCharacter/TabContainer/Equipment/SkeletonSlot/Skeleton.connect("pressed", self, "unequip_skeleton")
	#$ActiveCharacter/TabContainer/Equipment/BrainSlot/Brain.connect("pressed", self, "unequip_brain")
	#$ActiveCharacter/TabContainer/Equipment/NervousSystemSlot/NervousSystem.connect("pressed", self, "unequip_nervous_system")
	#$ActiveCharacter/TabContainer/Equipment/OperatingSystemSlot/OperatingSystem.connect("pressed", self, "unequip_operating_system")
	#$ActiveCharacter/TabContainer/Equipment/WeaponSlot/Weapon.connect("pressed", self, "unequip_weapon")
	$Characters/Character1/Control.connect("pressed", self, "choose_character", [1])
	$Characters/Character2/Control.connect("pressed", self, "choose_character", [2])
	$Characters/Character3/Control.connect("pressed", self, "choose_character", [3])
	$Characters/Character4/Control.connect("pressed", self, "choose_character", [4])
	$ActiveCharacter/StatsButton.connect("pressed", self, "goto_stats_tab")
	$ActiveCharacter/EquipmentButton.connect("pressed", self, "goto_equipment_tab")

func goto_stats_tab():
	$ActiveCharacter/TabContainer.current_tab = 0
	$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/EquipmentAcceptableBrainSlot.active = false
	$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/EquipmentAcceptableSkeletonSlot.active = false
	$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/EquipmentAcceptableWeaponSlot.active = false
	$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/EquipmentAcceptableNervousSystemSlot.active = false
	$ActiveCharacter/TabContainer/Equipment/EquipmentFoodSlot/EquipmentAcceptableFoodSlot.active = false
	$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/EquipmentAcceptableOperatingSystemSlot.active = false
func goto_equipment_tab():
	$ActiveCharacter/TabContainer.current_tab = 1
	$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/EquipmentAcceptableBrainSlot.active = true
	$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/EquipmentAcceptableSkeletonSlot.active = true
	$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/EquipmentAcceptableWeaponSlot.active = true
	$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/EquipmentAcceptableNervousSystemSlot.active = true
	$ActiveCharacter/TabContainer/Equipment/EquipmentFoodSlot/EquipmentAcceptableFoodSlot.active = true
	$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/EquipmentAcceptableOperatingSystemSlot.active = true
	
func choose_character(var i):
	if team.get_character(i):
		team.chosen_character = team.get_character(i)
	#print("team.chosen_character ", str(team.chosen_character.name))
	update_chosen_character()
	
func update_chosen_character():
	var ch = team.chosen_character
	$ActiveCharacter/CharacterName.text = ch.name
	$ActiveCharacter/Condition.texture = load("res://ui/sprites/"+ch.condition_type.to_lower()+"_icon.png")
	$ActiveCharacter/Character.texture = ch.get_node("Sprite").texture
	$ActiveCharacter/SlotBackground.texture = load("res://ui/sprites/inventory_character_slot_"+ch.condition_type.to_lower()+".png")
	$ActiveCharacter/Outline.texture = load("res://ui/sprites/inventory_character_slot_outline_"+ch.rarity.to_lower()+".png")
	var inst
	if ch.weapon():
		$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/Equipment.texture = ch.weapon().get_node("Sprite").texture
		inst = load(ch.weapon().inventory_item).instance()
		$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/Background.texture = load("res://ui/sprites/inventory_item_slot_" + inst.rarity.to_lower() + ".png")
		inst.free()
	else:
		$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/Equipment.texture = load("res://ui/sprites/inventory_weapon_slot.png")
		$ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/Background.texture = load("res://ui/sprites/inventory_item_slot.png")
	
	if ch.skeleton():
		$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/Equipment.texture = ch.skeleton().get_node("Sprite").texture
		inst = load(ch.skeleton().inventory_item).instance()
		$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/Background.texture = load("res://ui/sprites/inventory_item_slot_" + inst.rarity.to_lower() + ".png")
		inst.free()
	else:
		$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/Equipment.texture = load("res://ui/sprites/inventory_skeleton_slot.png")
		$ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/Background.texture = load("res://ui/sprites/inventory_item_slot.png")
	
	if ch.brain():
		$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/Equipment.texture = ch.brain().get_node("Sprite").texture
		inst = load(ch.brain().inventory_item).instance()
		$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/Background.texture = load("res://ui/sprites/inventory_item_slot_" + inst.rarity.to_lower() + ".png")
		inst.free()
	else:
		$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/Equipment.texture = load("res://ui/sprites/inventory_brain_slot.png")
		$ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/Background.texture = load("res://ui/sprites/inventory_item_slot.png")
	
	if ch.nervous_system():
		$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/Equipment.texture = ch.nervous_system().get_node("Sprite").texture
		inst = load(ch.nervous_system().inventory_item).instance()
		$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/Background.texture = load("res://ui/sprites/inventory_item_slot_" + inst.rarity.to_lower() + ".png")		
		inst.free()
	else:
		$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/Equipment.texture = load("res://ui/sprites/inventory_nervous_system_slot.png")
		$ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/Background.texture = load("res://ui/sprites/inventory_item_slot.png")
	
	if ch.operating_system():
		$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/Equipment.texture = ch.operating_system().get_node("Sprite").texture
		inst = load(ch.operating_system().inventory_item).instance()
		$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/Background.texture = load("res://ui/sprites/inventory_item_slot_" + inst.rarity.to_lower() + ".png")
		inst.free()
	else:	
		$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/Equipment.texture = load("res://ui/sprites/inventory_operating_system_slot.png")
		$ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/Background.texture = load("res://ui/sprites/inventory_item_slot.png")
	
	
func update_all_characters():
	var characters = team.get_character_slots()
	var i = 0
				
	for slot in $Characters.get_children():
		if i == 4:
			return
		if characters[i] != null:
			slot.get_node("Character").texture = characters[i].get_node("Sprite").texture
			slot.get_node("SlotBackground").texture = load("res://ui/sprites/inventory_character_slot_"+characters[i].condition_type.to_lower()+".png")
			slot.get_node("Outline").texture = load("res://ui/sprites/inventory_character_slot_outline_"+characters[i].rarity.to_lower()+".png")
		else:
			slot.get_node("Character").texture = null
			slot.get_node("SlotBackground").texture = load("res://ui/sprites/inventory_character_slot.png")
		i = i + 1
		
func unequip_weapon():
	if team.chosen_character.weapon():
		team.chosen_character.weapon().unequip()
		update_chosen_character()
func unequip_skeleton():
	if team.chosen_character.skeleton():
		team.chosen_character.skeleton().unequip()
		update_chosen_character()
func unequip_brain():
	if team.chosen_character.brain():
		team.chosen_character.brain().unequip()
		update_chosen_character()		
func unequip_nervous_system():
	if team.chosen_character.nervous_system():
		team.chosen_character.nervous_system().unequip()
		update_chosen_character()
func unequip_operating_system():
	if team.chosen_character.operating_system():
		team.chosen_character.operating_system().unequip()
		update_chosen_character()
		
func _input(InputEvent) -> void:
	if Input.is_action_just_pressed("ui_open_inventory"):
		open_inventory()
	
func open_inventory():
	team.chosen_character = team.get_active_character()
	goto_equipment_tab()
	update_all_characters()	
	is_opened = !is_opened
	visible = !visible
	if !visible and $Rect/ItemList.selected_draggable:
		$Rect/ItemList.selected_draggable.uncapture(false)
	var ui = get_parent()
	ui.get_node("TeamHpBar").visible = !ui.get_node("TeamHpBar").visible
	ui.get_node("Skills").visible = !ui.get_node("Skills").visible
	ui.get_node("MiniMap").visible = !ui.get_node("MiniMap").visible
	update_chosen_character()
	if visible == false:
		pass
	for character in team.get_characters():
		character.get_node("StateMachine").transition_to("Idle")
	get_tree().paused = !get_tree().paused

func _process(delta: float) -> void:
	update_chosen_character()
	$Cursor.position = get_global_mouse_position()
	#$ActiveCharacter/TabContainer.get_ta
	
