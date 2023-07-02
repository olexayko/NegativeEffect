extends Pickup
class_name InventoryPickup

#export(String, FILE, "*.tscn") var inventory_item
var inventory_item

func _ready() -> void:
	inventory_item = filename.replace("_pickup.tscn", "_item.tscn")

func condition(team):
	return team.inventory.get_free_slot() != null

func on_pickup(var team: Team):
	if .on_pickup(team) == false:
		return
	var item = inventory_item
	team.inventory.add_item(inventory_item)
	queue_free()
