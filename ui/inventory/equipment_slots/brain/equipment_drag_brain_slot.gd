extends Node2D

var content
export(NodePath) var equipment_slot
var captured = false
var active = true
var acceptable_groups = ["inventory_accept_slot", "inventory_drop_slot", "inventory_drag_slot"]
var team: Team
export(String, "Brain", "NervousSystem", "OperatingSystem", "Weapon", "Skeleton", "Food") var equipment_type

func _ready() -> void:
	add_to_group("equipment_drag_slot")
	$Control.connect("gui_input", self, "slot_input")
	modulate.a = 0
	
func slot_input(event):
	if event.is_action_pressed("attack"):
		#print(filename)
		if team.chosen_character.call(Global.pascal_to_snake(equipment_type)):
			capture()
		else:
			var slot = team.inventory.selected_slot
			#print(slot.get_item().equipment_type.to_lower(), ", ", equipment_type)
			#print(slot.get_item().equipment_type, team.chosen_character.attack_type.to_lower())
			if slot and slot.get_item() \
				and (slot.get_item().equipment_type == equipment_type or slot.get_item().equipment_type == team.chosen_character.attack_type):
				slot.get_item().equip()
				team.inventory.unselect()
				#print("slot.get_item().equipment_type = ", slot.get_item().equipment_type)
	if event.is_action_released("attack"):
		uncapture(true)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		uncapture(false)
	
func on_capture():
	modulate.a = 1
	owner.get_node("Equipment").modulate.a = 0.5
	#content.self_modulate.a = 0.5

func on_uncapture():
	modulate.a = 0
	owner.get_node("Equipment").modulate.a = 1
	#get_parent().modulate.a = 1
	
func capture():
	var brain = get_node(equipment_slot).inventory.team.chosen_character.brain()
	if not brain:
		return
	
	$Control/Sprite.texture = brain.get_node("Sprite").texture
	
	print(brain)
	print("CAPTURE")
	captured = true
	content = brain

	on_capture()
	print("content captured = ", content)

func colliding_rect():
	var rect: Rect2
	rect.size = $Control.get_rect().size
	rect.position = global_position
	return rect

func get_colliding_rects(groups: Array = acceptable_groups):
	var slots = []
	for gr in groups:
		for el in get_tree().get_nodes_in_group(gr):
			if colliding_rect().clip(el.colliding_rect()):
				#print("Collision: ", self, " with ", el, " Intersection: ", colliding_rect().clip(el.colliding_rect()).get_area())
				slots.append(el)
	return slots
	
func get_closest_rect(slots: Array = get_colliding_rects()):
	if slots.size() == 0:
		return null
	var slots_intersection_areas = []
	for slot in slots:
		var area = colliding_rect().clip(slot.colliding_rect()).get_area()
		slots_intersection_areas.push_back(area)
	var closest_slot = slots[slots_intersection_areas.find(slots_intersection_areas.max())]
	return closest_slot
		
func uncapture(b: bool):
	if not captured:
		return
	if b:
		print("UNCAPTURE")
	$Control/Sprite.texture = null #get_node(equipment_slot).get_item().texture_normal
	
	if get_closest_rect():
		var gr = get_closest_rect().get_groups()[0]
		match gr:
			"inventory_drop_slot":
				content.drop()
			"inventory_accept_slot":
				release_content()
	print("get_closest_rect() = ", get_closest_rect())
	position = Vector2.ZERO
	captured = false
	on_uncapture()

func _process(delta: float) -> void:
	if not captured:
		return
	global_position = get_global_mouse_position() - $Control.rect_size / 2
	if get_closest_rect():
		match get_closest_rect().get_groups()[0]:
			"inventory_drop_slot":
				pass
			"inventory_accept_slot":
				if not get_closest_rect().get_node(get_closest_rect().inventory_slot).get_item():
					var slot = get_closest_rect().get_node(get_closest_rect().inventory_slot)
					slot.highlight()
					slot.get_node("Unhighlight").start(slot.highlight_time)					

		
func release_content():
	var target = get_closest_rect().get_node(get_closest_rect().inventory_slot)
	var group = get_closest_rect().get_groups()[0]
	var c = load(content.inventory_item).instance()
	print("group = ", group)
		
	if not get_closest_rect().get_node(get_closest_rect().inventory_slot).get_item():
		
		content.queue_free()
		target.item_list.add_item(content.inventory_item, target)
		team.inventory.unselect()
		target.set_selection(true)
		target.unhighlight()
	#comment section below to disable in-inventory items swap
