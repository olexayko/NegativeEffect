# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

signal transitioned(state_name)

export(NodePath) var initial_state
var character
onready var state: State = get_node(initial_state)

func _ready() -> void:
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_string: String) -> void:
	if !has_node(target_state_string):
		print("Nonexistent state: " + target_state_string)
		return
	state.exit()
	state = get_node(target_state_string)
	state.enter()
	emit_signal("transitioned", state.name)

