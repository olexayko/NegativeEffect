extends CharacterState

func enter(_msg := {}) -> void:
	character.get_node("AnimationPlayer").play("Idle" + character.facing.capitalize())

func update(_delta: float) -> void:
	process_attack()
	process_skills()
	process_dash()
	if character.team.is_attacking == false:
		if (Input.get_action_strength("move_down") - Input.get_action_strength("move_up") or (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))):
			state_machine.transition_to("Run")
