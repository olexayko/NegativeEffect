extends Pickup
class_name PickableCharacter

export(PackedScene) var character

func condition(team):
	return team.get_character_amount() != 4

func on_pickup(var team: Team):
	if .on_pickup(team) == false:
		return
		
	print("added " + str(team))
	team.add_character(character)
	queue_free()
