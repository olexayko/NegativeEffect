extends CharacterState

func physics_update(_delta: float) -> void:
	process_attack()
	process_skills()
	process_dash()
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var input_direction_y: float = (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
	)
	if !input_direction_y and !input_direction_x:#is_equal_approx(input_direction_x, 0.0) and is_equal_approx(input_direction_y, 0.0):
		state_machine.transition_to("Idle")
		
	if !(input_direction_x == 0 and input_direction_y == 0):
		character.direction = Vector2(input_direction_x, input_direction_y)
	if !character.team.is_attacking:
		character.team.move_and_slide(character.direction.normalized() * character.team.speed / character.team.get_character_amount())
	
	var x = input_direction_x
	var y = input_direction_y
	
	if x == 0 and y == 1: 
		#character.get_node("Sprite").frame = 8
		character.get_node("AnimationPlayer").play("RunDown")
		character.facing = "down"
	elif x == 0 and y == -1:
		#character.get_node("Sprite").frame = 5
		character.get_node("AnimationPlayer").play("RunUp")
		character.facing = "up"
	elif x == 1:
		#character.get_node("Sprite").frame = 7
		character.get_node("AnimationPlayer").play("RunRight")
		character.facing = "right"
	elif x == -1:
		#character.get_node("Sprite").frame = 6
		character.get_node("AnimationPlayer").play("RunLeft")
		character.facing = "left"
			
		
		

