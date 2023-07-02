extends Node2D

var content
export(NodePath) var inventory_slot
var acceptable_groups = ["inventory_accept_slot", "inventory_drop_slot", "equipment_accept_slot"]

var captured = false
var capturing = false
var capturing_time = 0

func _ready() -> void:
	add_to_group("inventory_drag_slot")
	$Control.connect("gui_input", self, "gui")
	$RemainForCapture.connect("timeout", self, "capture")
	modulate.a = 0

"""
func set_mouse(b: bool):	
	mouse_on = b
	print("mouse_on = ", mouse_on)
"""

var LastPressedTime = 0
var time_for_dc = 0.2
var time_for_capture = 0.1


func gui(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and Input.is_action_just_pressed("attack"):
		print("is_action_just_pressed")
		$RemainForCapture.start(time_for_capture)
		capturing = true
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and Input.is_action_just_released("attack"):
		$RemainForCapture.stop()
		capturing = false
		uncapture(true)
		print("is_action_just_released")
		
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		OnSingleClick(get_local_mouse_position())
		print("gui")
		if (LastPressedTime > 0):
			OnDoubleClick(get_local_mouse_position())
			LastPressedTime = 0
		else:
			LastPressedTime = time_for_dc
			
func _process(delta: float) -> void:
	if (LastPressedTime > 0):
		LastPressedTime = max(0, LastPressedTime - delta)
		#print("PROCESS")
		if (LastPressedTime == 0):
			pass
			#OnSingleClick(get_local_mouse_position())
	"""if not $RemainForCapture.get_time_left() and capturing:
		capture()"""
	process_captured()

func process_captured():
	if captured:
		global_position = get_global_mouse_position() - $Control.rect_size / 2
		#process collisions	
		if get_closest_rect():
			match get_closest_rect().get_groups()[0]:
				"inventory_drop_slot":
					pass
				"inventory_accept_slot":
					var slot = get_closest_rect().get_node(get_closest_rect().inventory_slot)
					if not slot.get_item():
						slot.highlight()
						slot.get_node("Unhighlight").start(slot.highlight_time)
		#if Input.is_action_just_released("attack"):
		#	uncapture(true)
						
func OnDoubleClick(position):
	if get_node(inventory_slot).get_item():
		if get_node(inventory_slot).get_item().has_method("equip"):
			get_node(inventory_slot).get_item().equip()
			get_node(inventory_slot).set_selection(false)
	print("double: "+str(position.x)+","+str(position.y))

func OnSingleClick(position):
	if get_node(inventory_slot).trigger_single_click:
		get_node(inventory_slot).set_selection(!get_node(inventory_slot).selected)
	get_node(inventory_slot).trigger_single_click = true
	#get_node(inventory_slot).set_selection(true)
	#capture()
	print("single: "+str(position.x)+","+str(position.y))
	
	#if not event is InputEventMouseMotion:
	#	print(event)
	
	"""
	if event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and event.doubleclick:	
		print("2-click")
		
	elif Input.is_action_just_pressed("attack"):
		get_node(inventory_slot).set_selection(!get_node(inventory_slot).selected)
		print("selection")

		#if not get_node(inventory_slot).selected:
		#	get_node(inventory_slot).set_selection(true)
	pass 
	"""
"""	
func _input(ev: InputEvent) -> void:
	for o in get_tree().get_nodes_in_group("inventory_drag_slot"):
		o.mouse_on = false
	if mouse_collides() == self:
		mouse_on = true
	if not mouse_on:
		get_parent().get_node("Label").text = ""
	if mouse_on:
		if Input.is_action_pressed("attack"):
			print("HOLDING LMB")
			if capturing_time >= time_for_capture:
				capture()
			
		get_parent().get_node("Label").text = str(mouse_collides())
		if Input.is_action_just_pressed("attack"):
			if not get_node(inventory_slot).selected:
				get_node(inventory_slot).set_selection(true)
			if get_node(inventory_slot).selected:
				if ev is InputEventMouseButton 
				and ev.button_index == BUTTON_LEFT 
				and ev.doubleclick:
					if get_node(inventory_slot).get_item().has_method("equip"):
						get_node(inventory_slot).get_item().equip()
		
	if Input.is_action_just_released("attack"):
		#print("released lmb")
		capturing_time = 0
		uncapture(true)	
	if not captured:
		return
	"""

"""
	for o in get_tree().get_nodes_in_group("inventory_drag_slot"):
		o.mouse_on = false
	if mouse_collides() == self:
		mouse_on = true
	if not mouse_on:
		get_parent().get_node("Label").text = ""
	if mouse_on:
		get_parent().get_node("Label").text = str(mouse_collides())
		if Input.is_action_just_pressed("attack"):
			if not get_node(inventory_slot).selected:
				get_node(inventory_slot).set_selection(true)
			if get_node(inventory_slot).selected:
				if doubleclick:
					if get_node(inventory_slot).get_item().has_method("equip"):
						get_node(inventory_slot).get_item().equip()"""
"""
	if mouse_on:
		if Input.is_action_pressed("attack"):
			capturing_time += delta
			if capturing_time >= time_for_capture:
				capturing_time = 0
				capture()		
	if captured:
		#process collisions	
		global_position = get_global_mouse_position() - $Control.rect_size / 2
		if get_closest_rect():
			match get_closest_rect().get_groups()[0]:
				"inventory_drop_slot":
					pass
				"inventory_accept_slot":
					var slot = get_closest_rect().get_node(get_closest_rect().inventory_slot)
					if not slot.get_item():
						slot.highlight()
						slot.get_node("Unhighlight").start(slot.highlight_time)					
	"""
			
func slot_input(event):
	pass
	"""
	if event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and 1
		print("holding lmb")
	"""
	#and event.pressed:
	"""
	if get_node(inventory_slot).selected:
		if event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and event.pressed:
			get_node(inventory_slot).set_selection(!get_node(inventory_slot).selected)
			if get_node(inventory_slot).get_item():
				get_node(inventory_slot).get_item().equip()
				get_node(inventory_slot).item_list.selected_slot = null
				print("equip()")
				
		elif event.is_action_pressed("attack"):
			capture()	
		elif event.is_action_released("attack"):
			uncapture(true)
			
	if not get_node(inventory_slot).selected:
		if event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and event.doubleclick:
			print("event = ", event.button_index)
			if get_node(inventory_slot).get_item() 
			and get_node(inventory_slot).get_item().has_method("equip"):
				get_node(inventory_slot).get_item().equip()

		elif event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and event.pressed:
			get_node(inventory_slot).set_selection(!get_node(inventory_slot).selected)
			
		elif event.is_action_pressed("attack"):
			capture()	
		elif event.is_action_released("attack"):
			uncapture(true)
	"""
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		uncapture(false)

func capture():
	#capturing_time = 0
	if not get_node(inventory_slot).get_item():
		return
	captured = true
	get_parent().item_list.selected_draggable = self
	$Control/Sprite.texture = get_node(inventory_slot).get_item().texture
	print(get_node(inventory_slot).get_item())
	print("CAPTURE")
	modulate.a = 1
	content = get_node(inventory_slot).get_item()
	content.self_modulate.a = 0.5
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
	get_parent().item_list.selected_draggable = null
	capturing_time = 0
	if b:
		print("UNCAPTURE")
	$Control/Sprite.texture = get_node(inventory_slot).get_item().texture
	
	if get_closest_rect():
		#if not get_closest_rect().get_node(get_closest_rect().inventory_slot).get_item():
		match get_closest_rect().get_groups()[0]:
			"inventory_drop_slot":
				content.drop()
				get_node(inventory_slot).set_selection(false)
			"inventory_accept_slot":
				release_content()	
			"equipment_accept_slot":
				if not get_closest_rect().active:
					continue
				if "/" + get_closest_rect().get_parent().equipment_type + "s/" in content.filename:
					content.equip()
					get_node(inventory_slot).item_list.unselect()
	#print("get_closest_rect() = ", get_closest_rect())
	position = Vector2.ZERO
	captured = false
	content.self_modulate.a = 1
	modulate.a = 0
		
#func release_content(group = get_closest_rect().get_groups()[0], target = get_closest_rect().get_node(get_closest_rect().inventory_slot)):
func release_content(target = get_closest_rect().get_node(get_closest_rect().inventory_slot)):
	#print("group = ", group)
	if not get_closest_rect().get_node(get_closest_rect().inventory_slot).get_item():
		Global.reparent_node(content, target.get_node("Item"))
		target.unhighlight()
		if get_node(inventory_slot).item_list.selected_slot:
			get_node(inventory_slot).item_list.selected_slot.set_selection(false)
		get_node(inventory_slot).item_list.selected_slot = target
		get_node(inventory_slot).item_list.selected_slot.set_selection(true)
		#target.get_node("InventoryDragSlot").mouse_on = true
	#comment section below to disable in-inventory items swap
	else:
		var content1 = content.get_parent()
		var target1 = target.get_item()
		Global.reparent_node(content, target.get_node("Item"))
		Global.reparent_node(target1, content1)
		
		if get_node(inventory_slot).item_list.selected_slot:
			get_node(inventory_slot).item_list.selected_slot.set_selection(false)
		get_node(inventory_slot).item_list.selected_slot = null
		get_node(inventory_slot).item_list.selected_slot = target
		get_node(inventory_slot).item_list.selected_slot.set_selection(true)

"""
func mouse_collides():
	for slot in get_tree().get_nodes_in_group("inventory_drag_slot"):
		if slot.colliding_rect().has_point(get_global_mouse_position()) 
		and get_node(inventory_slot).item_list.inventory_ui.is_opened:
			return slot
"""
