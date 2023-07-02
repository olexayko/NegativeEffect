extends Control
class_name ItemsList

var team 
var selected_slot
var inventory_ui
var selected_draggable

func _ready() -> void:
	yield(owner, "ready")
	team = owner.owner.owner
	#print(owner)
	for inv_slot in $Rows/Row1.get_children() + $Rows/Row2.get_children() + $Rows/Row3.get_children():
		inv_slot.item_list = self

"""
func set_selected(node, b):
	node.selected = b
	node.get_node("SelectedBorder").visible = b
	print("set_selected() called")
	#$EquipButton.connect("pressed", self, "equip_selected_item")
	#$DropButton.connect("pressed", self, "drop_selected_item")
"""

func unselect():
	if selected_slot:
		selected_slot.set_selection(false)
	
	
func get_items():
	var items: Array = []
	var row1 = $Rows/Row1
	var row2 = $Rows/Row2
	var row3 = $Rows/Row3
	for item in row1.get_children():
		if item.get_child_count() == 1:
			items.append(item.get_child(0))
	for item in row2.get_children():
		if item.get_child_count() == 1:
			items.append(item.get_child(0))	
	for item in row3.get_children():
		if item.get_child_count() == 1:
			items.append(item.get_child(0))		
	return items

func get_slots():
	var slots: Array = []
	for slot in $Rows/Row1.get_children():
		slots.append(slot)
	for slot in $Rows/Row2.get_children():
		slots.append(slot)
	for slot in $Rows/Row3.get_children():
		slots.append(slot)
	return slots

func get_free_slot():
	for slot in get_slots():
		if slot.get_node("Item").get_child_count() == 0:
			return slot
	
func add_item(item: String, slot = get_free_slot()):
	var i = load(item).instance()
	i.item_list = team.inventory
	slot.get_node("Item").add_child(i)
	#print(i.item_list)
	#print(team.inventory)

