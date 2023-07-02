extends InventoryItem
class_name InventoryEquipmentItem
#export(String, FILE, "*.tscn") var equipment
var equipment

func _ready() -> void:
	equipment = filename.replace("_item.tscn", ".tscn")
	pickup = filename.replace("_item.tscn", "_pickup.tscn")
	
func equip(): #virtual
	pass
