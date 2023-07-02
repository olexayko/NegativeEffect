extends Enemy

var received_damage = 0
func _ready():
	#get_node("area").connect("body_entered", self, "damage_melee")
	#add_to_group("enemies")
	pass

func take_damage(var dmg):
	received_damage += dmg
	$Label.text = "dmg: " + str(received_damage)

func die():
	queue_free()

