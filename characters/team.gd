extends Node2D
class_name Team

var location

var current_character_id = 1
var previous_character_id
var switch_cooldown = 0.5
var max_characters_amount = 4
var is_attacking = false

var hp = 3
var max_hp = 6

var inventory 
var chosen_character

export(float) var speed

export(int) var inventory_limit

export(PackedScene) var ch1
export(PackedScene) var ch2
export(PackedScene) var ch3
export(PackedScene) var ch4

func get_character(var idx):
	if get_node_or_null("Character" + str(idx)).get_child_count():
		return get_node_or_null("Character" + str(idx)).get_child(0)

func add_character(character_res: PackedScene, idx = get_free_slot_index()):
	var ch = character_res.instance()
	get_node("Character" + str(idx)).add_child(ch)
	ch.team = self
	disable(ch)
	disable(get_node("Character" + str(idx)).get_child(0))
	
func get_character_amount():
	var i = 1
	var j = 0
	while i <= max_characters_amount:
		j += get_node("Character" + str(i)).get_child_count()
		i += 1
	return j
	
func get_active_character():
	return get_character(current_character_id)

func get_character_slots():
	var c1 = $Character1.get_child(0)
	var c2 = $Character2.get_child(0)
	var c3 = $Character3.get_child(0)
	var c4 = $Character4.get_child(0)
	return [c1, c2, c3, c4]

func get_characters():
	var arr = [get_active_character()]
	for c in get_inactive_characters():
		arr.append(c)
	
	#print("teamamates:", arr)
	return arr

func get_inactive_characters():
	var chars = []
	for i in range(1, max_characters_amount + 1):
		if get_character(i) and get_character(i) != get_active_character():
			chars.append(get_character(i))
	return chars

func get_free_slot_index():
	for i in range(1, max_characters_amount + 1):
		if !get_character(i):
			return i
	return 0

func _ready():	
	$UI.team = self
	$StatusHolder.team = self
	inventory = $UI/InventoryUI/Rect/ItemList
	$UI/InventoryUI/ActiveCharacter/TabContainer/Equipment/EquipmentBrainSlot/EquipmentDragBrainSlot.team = self
	$UI/InventoryUI/ActiveCharacter/TabContainer/Equipment/EquipmentFoodSlot/EquipmentDragFoodSlot.team = self
	$UI/InventoryUI/ActiveCharacter/TabContainer/Equipment/EquipmentNervousSystemSlot/EquipmentDragNervousSystemSlot.team = self
	$UI/InventoryUI/ActiveCharacter/TabContainer/Equipment/EquipmentSkeletonSlot/EquipmentDragSkeletonSlot.team = self
	$UI/InventoryUI/ActiveCharacter/TabContainer/Equipment/EquipmentOperatingSystemSlot/EquipmentDragOperatingSystemSlot.team = self
	$UI/InventoryUI/ActiveCharacter/TabContainer/Equipment/EquipmentWeaponSlot/EquipmentDragWeaponSlot.team = self
	add_character(ch1, 1)
	add_character(ch2, 2)
	add_character(ch3, 3)
	add_character(ch4, 4)
	enable(get_character(current_character_id))

func pickup(var pickups: Array):
	if !pickups.size():
		return
	var distances_to_pickups = []
	for pickup in pickups:
		distances_to_pickups.append(pickup.global_position.distance_to(global_position))
	pickups[distances_to_pickups.find(distances_to_pickups.min())].owner.on_pickup(self)
	
func update_pickup_labels(var pickups: Array):
	if !pickups.size():
		return
	var distances_to_pickups = []
	for pickup in pickups:
		distances_to_pickups.append(pickup.owner.global_position.distance_to(global_position))
	var nearest_pickup = pickups[distances_to_pickups.find(distances_to_pickups.min())].owner
	nearest_pickup.get_node("Label/Timer").start(nearest_pickup.label_ping)	

func _input(event):  
	if !$SwitchCooldown.get_time_left() and !is_attacking:
		if Input.is_action_pressed("next_character"):
			character_switch(get_next_char())
		if Input.is_action_pressed("previous_character"):
			character_switch(get_previous_char()) 
		if Input.is_action_just_pressed("character1") and get_character(1):
			character_switch(1)	
		if Input.is_action_just_pressed("character2") and get_character(2):
			character_switch(2)		 
		if Input.is_action_just_pressed("character3") and get_character(3):
			character_switch(3) 
		if Input.is_action_just_pressed("character4") and get_character(4):
			character_switch(4)
	if Input.is_action_just_pressed("pickup"):
		pickup($PickupArea.get_overlapping_areas())

		
					
func get_next_char():
	if get_character_amount() == 1:
		return current_character_id	
	if current_character_id == 1:
		if $Character2.get_child_count() != 0:
			return 2
		if $Character3.get_child_count() != 0:
			return 3
		if $Character4.get_child_count() != 0:
			return 4
	if current_character_id == 2:
		if $Character3.get_child_count() != 0:
			return 3
		if $Character4.get_child_count() != 0:
			return 4
		if $Character1.get_child_count() != 0:
			return 1
	if current_character_id == 3:
		if $Character4.get_child_count() != 0:
			return 4
		if $Character1.get_child_count() != 0:
			return 1
		if $Character2.get_child_count() != 0:
			return 2
	if current_character_id == 4:
		if $Character1.get_child_count() != 0:
			return 1
		if $Character2.get_child_count() != 0:
			return 2
		if $Character3.get_child_count() != 0:
			return 3

func get_previous_char():
	if get_character_amount() == 1:
		return current_character_id	
	if current_character_id == 1:
		if $Character4.get_child_count() != 0:
			return 4
		if $Character3.get_child_count() != 0:
			return 3
		if $Character2.get_child_count() != 0:
			return 2
	if current_character_id == 2:
		if $Character1.get_child_count() != 0:
			return 1
		if $Character4.get_child_count() != 0:
			return 4
		if $Character3.get_child_count() != 0:
			return 3
	if current_character_id == 3:
		if $Character2.get_child_count() != 0:
			return 2
		if $Character1.get_child_count() != 0:
			return 1
		if $Character4.get_child_count() != 0:
			return 4
	if current_character_id == 4:
		if $Character3.get_child_count() != 0:
			return 3
		if $Character2.get_child_count() != 0:
			return 2
		if $Character1.get_child_count() != 0:
			return 1
 
func character_switch(var idx):
	if idx == current_character_id:
		return
	disable(get_active_character())
	previous_character_id = current_character_id
	current_character_id = idx
	enable(get_active_character())
	$SwitchCooldown.start(switch_cooldown)

func disable(var node):
	#pass
	node.visible = false
	
func enable(var node):
	node.visible = true

func take_damage(var dmg):
	hp = max(hp - dmg, 0)
		
func take_heal(var heal):
	hp = min(hp + heal, max_hp)

func get_enemies():
	var enemies = []
	for area in get_active_character().get_node("AutoAim").get_overlapping_areas():
		enemies.append(area.owner)
	return enemies

func _process(delta):
	update_pickup_labels($PickupArea.get_overlapping_areas())
	#$Label.text = str(get_active_character().get_node("StateMachine").state.name) + "\n" + str(get_active_character().name)
	

