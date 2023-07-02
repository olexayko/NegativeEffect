extends CharacterState

export(NodePath) var next_state

func physics_update(_delta: float) -> void:
	state_machine.transition_to(Global.np_last(next_state))
