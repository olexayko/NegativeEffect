extends State
class_name CharacterState

var character: Character

func _ready() -> void:
	yield(owner, "ready")
	character = owner as Character
	assert(character != null)

func process_dash():
	if Input.is_action_just_pressed("dash") \
		and !character.get_node("StateMachine/Dodge/Cooldown").get_time_left() \
		and !character.get_node("StateMachine/Dash/Cooldown").get_time_left():	
			
		var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
		)
		var input_direction_y: float = (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
		)
		if !(input_direction_x == 0 and input_direction_y == 0):
			character.direction = Vector2(input_direction_x, input_direction_y)
		state_machine.transition_to("Dash")	

	elif Input.is_action_just_pressed("dodge") \
	and !character.get_node("StateMachine/Dodge/Cooldown").get_time_left() \
	and !character.get_node("StateMachine/Dash/Cooldown").get_time_left():
		state_machine.transition_to("Dodge")	
		
func process_attack():
	if Input.is_action_just_pressed("attack") and character == character.team.get_active_character():
		if character.weapon():
			print("Have gun")
			state_machine.transition_to(Global.np_last(character.attack))
		else:
			print("no gun")
			
func process_skills():
	var common_skill = character.get_node("StateMachine").get_node(character.common_skill.get_name(character.common_skill.get_name_count() - 1))
	var ultimate_skill = character.get_node("StateMachine").get_node(character.ultimate_skill.get_name(character.ultimate_skill.get_name_count() - 1))
	
	if Input.is_action_pressed("common_skill") and character.team.get_active_character() == character:
		if common_skill and !common_skill.get_node("Timer").get_time_left():
			if common_skill.energy_cost <= common_skill.energy:
				state_machine.transition_to(common_skill.name)
				
	if Input.is_action_pressed("ultimate_skill") and character.team.get_active_character() == character:
		if ultimate_skill and !ultimate_skill.get_node("Timer").get_time_left():
			if ultimate_skill.energy_cost <= ultimate_skill.energy:
				state_machine.transition_to(ultimate_skill.name)
		
func get_target():
	var team_position = character.team.global_position	
	var enemies = character.team.get_enemies()
	var distances = []	
	for enemy in enemies:
		distances.push_back(enemy.global_position.distance_to(team_position))
	var target 
	if distances.find(distances.min()) != -1:
		target = enemies[distances.find(distances.min())]
	return target






