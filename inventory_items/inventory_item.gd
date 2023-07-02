extends Node2D
class_name InventoryItem

export(String, "Common", "Uncommon", "Rare", "Epic", "Legendary") var rarity
var item_list
export (String, FILE, "*.tscn") var pickup

func _ready():
	$Sprite.texture = load("res://ui/sprites/inventory_item_slot_"+rarity.to_lower()+".png")

func drop():
	var pick = load(pickup).instance()
	pick.global_position = item_list.team.global_position
	get_node("/root/world").add_child(pick)
	queue_free()
	
func move_to_slot(slot: Node):
	var d = duplicate()
	slot.add_child(d)
	queue_free()


	
