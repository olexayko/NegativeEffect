extends CharacterState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func enter(_msg := {}) -> void:
	state_machine.transition_to(character.attack_type)
