extends CharacterState
class_name Ability

export(float) var energy_cost = 50.0
export(float) var cooldown = 3.0

export(Texture) var icon_under_16
export(Texture) var icon_over_16
export(Texture) var icon_progress_16
export(Texture) var icon_under_32
export(Texture) var icon_over_32
export(Texture) var icon_progress_32

var energy: float = 0
	
func enter() -> void:
	print("Skill " + character.name)
	$Timer.start(cooldown)
	character.team.is_attacking = true
	energy -= energy_cost

func get_enemies():
	var enemies = []
	if get_node("AutoAim").get_overlapping_areas():
		for area in get_node("AutoAim").get_overlapping_areas():
			enemies.append(area.owner)
	return enemies

func get_target():
	var team_position = character.team.global_position	
	var enemies = get_enemies()
	var distances = []	
	for enemy in enemies:
		distances.push_back(enemy.global_position.distance_to(team_position))
	var target 
	if distances.find(distances.min()) != -1:
		target = enemies[distances.find(distances.min())]
	if target:
		print(target)
		return target
