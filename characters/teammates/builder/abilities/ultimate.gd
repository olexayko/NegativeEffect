extends Ability

var direction

var timestamp
var length: float = 0.45 + 0.5
var time: float = 0
var bullets_shooted = 0
var bullets_timestamps = [0.45]

func physics_update(_delta: float) -> void:
	if bullets_shooted != bullets_timestamps.size() and time >= bullets_timestamps[bullets_shooted]:
		shoot()
		bullets_shooted += 1
		
	if Input.is_action_pressed("dash"):
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
		
	time += _delta
	if time >= length:
		state_machine.transition_to("Idle")	
		
func exit():
	time = 0
	bullets_shooted = 0
	#character.get_node("Weapon").visible = false
	character.team.is_attacking = false
	for i in get_tree().get_nodes_in_group("player_fist_slash"):
		i.queue_free()
	
func shoot():
	#character.get_node("Weapon").visible = true
	var slash = load("res://attacks/fist_slash.tscn").instance()
	slash.global_position = character.get_node("ProjectileSpawn/" + str(character.facing).capitalize()).global_position
	match character.facing:
		"left":
			slash.direction = Vector2(-1, 0)
		"right":
			slash.direction = Vector2(1, 0)
		"up":
			slash.direction = Vector2(0, -1)
		"down":
			slash.direction = Vector2(0, 1)
	
	if character.facing == "up" or character.facing == "down":
		slash.rotation_degrees = 90
	#get_node("/root/world").add_child(slash)
	#slash.add_to_group("player_fist_slash")

