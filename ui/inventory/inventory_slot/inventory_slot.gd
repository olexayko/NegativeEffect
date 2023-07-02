extends Control
class_name InventorySlot
var highlight_time = 0.05
export(NodePath) var item_list
var selected = false 

func _ready() -> void:
	add_to_group("inventory_slots")
	$Unhighlight.connect("timeout", self, "unhighlight")
	connect("gui_input", self, "input")

func set_selection(b: bool):
	if item_list.selected_slot:
		var slot = item_list.selected_slot
		slot.get_node("SelectedBorder").visible = false
		slot.selected = false
		item_list.selected_slot = null
		
	$SelectedBorder.visible = b
	selected = b
	if b:
		item_list.selected_slot = self

var trigger_single_click = true

func input(event: InputEvent):
	if Input.is_action_just_pressed("attack") and item_list.selected_slot  \
	and item_list.selected_slot != self and item_list.selected_slot.get_item() != null \
		and get_item() == null:
		Global.reparent_node(item_list.selected_slot.get_item(), get_node("Item"))
		trigger_single_click = false
		set_selection(!selected)
	else:
		if Input.is_action_just_pressed("attack"):
			pass
			#print(Input.is_action_just_pressed("attack"), item_list.selected_slot, item_list.selected_slot != self, item_list.selected_slot.get_item(), get_item() == null)
		#set_selection(true)
		
	"""if event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and event.doubleclick:
		print("event = ", event.button_index)
		if get_item():
			get_item().equip()
	
	elif event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT 
		and event.pressed:
		set_selection(!selected)
	"""

	
func get_item():
	if $Item.get_child_count():
		return $Item.get_child(0)

func highlight():
	modulate.r = 1.5
	modulate.g = 1.5
	modulate.b = 1.5
	
func unhighlight():
	modulate.r = 1
	modulate.g = 1
	modulate.b = 1
