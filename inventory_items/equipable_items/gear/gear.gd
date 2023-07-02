extends Node2D
class_name Gear

#export(String, FILE, "*.tscn") var inventory_item
var inventory_item
var team: Team

func _ready() -> void:
	inventory_item = filename.replace(".tscn", "_item.tscn")

var stats = {
	"damage": 1,
	"defense": 3
}

func drop():
	var pick = load(load(inventory_item).instance().pickup).instance()
	pick.global_position = team.global_position
	get_node("/root/world").add_child(pick)
	queue_free()


func unequip():	
	#print("@@@")
	var inv = team.inventory
	if inv.get_free_slot() != null:
		inv.add_item(inventory_item) 
		queue_free()
