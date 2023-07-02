extends CharacterState
class_name BladeAttackState

export(NodePath) var next_attack_state

export(Array, float) var lengths# = [0.3, 1, 0.55, 0.45, 0.5]
#var lengths = [0.3, 1, 0.55, 0.45, 0.5]

var bullets_shooted = 0

var break_by_dash = false
var break_by_move = false
var break_by_abilities = false
var break_by_attack = false

var moving = true
var moving_power = 50

func enter() -> void:
	#time = 0
	character.team.is_attacking = true
	bullets_shooted = 0
	break_by_attack = false
	break_by_dash = false
	break_by_move = false
	break_by_abilities = false
	moving = true
	var iter = get_script().get_path()[-4]
	#print("blade iter = ", iter)
	
	if MeleeAttackCoords.get_side() == "left":
		character.direction = Vector2(-1, 0)
		character.facing = "left"
		character.get_node("AnimationPlayer").play("BladeAttack" + str(iter) + "Left")
	if MeleeAttackCoords.get_side() == "right":
		character.direction = Vector2(1, 0)
		character.facing = "right"
		character.get_node("AnimationPlayer").play("BladeAttack" + str(iter) + "Right")
	if MeleeAttackCoords.get_side() == "down":
		character.direction = Vector2(0, 1)
		character.facing = "down"
		character.get_node("AnimationPlayer").play("BladeAttack" + str(iter) + "Down")
	if MeleeAttackCoords.get_side() == "up":
		character.direction = Vector2(0, -1)
		character.facing = "up"
		character.get_node("AnimationPlayer").play("BladeAttack" + str(iter) + "Up")
	print(name + " enter")
	"""
	if get_target():
		character.get_node("ProjectileSpawn").rotation_degrees = rad2deg((get_target().global_position - character.team.global_position).angle())
		print(character.get_node("ProjectileSpawn").rotation_degrees)
	"""
	#print("^^^", Global.sum_array(lengths.slice(0, 0)))
	
	for i in range(0, 5):
		#print(i)
		get_node("Timer" + str(i)).start(Global.sum_array(lengths.slice(0, i)))
		get_node("Timer" + str(i)).connect("timeout", self, "timeout_" + str(i))
	
func timeout_0():
	print(name + " %0")
	moving = false
	shoot()
	bullets_shooted += 1


func timeout_1():
	print(name + " %1")
	pass

func timeout_2():
	print(name + " %2")
	break_by_move = true
	
func timeout_3():
	print(name + " %3")
	break_by_attack = true

func timeout_4():
	break_by_attack = false
	print(name + " %4")
	state_machine.transition_to("Idle")

func exit():
	for i in range(0, 5):
		#print("T_", i)
		get_node("Timer" + str(i)).disconnect("timeout", self, "timeout_" + str(i))
	#print(name + " exit")
	#time = 0
	bullets_shooted = 0
	break_by_dash = false
	break_by_move = false
	break_by_abilities = false
	break_by_attack = false
	character.get_node("ProjectileSpawn/Weapon").visible = false
	character.team.is_attacking = false
	character.get_node("ProjectileSpawn").rotation_degrees = 0
	for i in get_tree().get_nodes_in_group("player_sword_slash"):
		i.queue_free()

func physics_update(_delta: float) -> void:
	if break_by_dash:
		process_dash()
	if break_by_abilities:
		process_skills()
	if break_by_move:
		process_move()
	if break_by_attack:
		process_combo_attack()
	if moving:
		process_moving()
	#time += _delta

func process_moving():
	#print(character.get_node('ProjectileSpawn').rotation_degrees)
	var deg = character.get_node('ProjectileSpawn').rotation_degrees
	if deg == 0:
		character.team.move_and_slide(character.direction.normalized() * moving_power)
	else:
		character.team.move_and_slide((Vector2(1, 0) * moving_power).rotated(deg2rad(deg)))
	
func process_combo_attack():
	if Input.is_action_just_pressed("attack"):
		if next_attack_state:
			state_machine.transition_to(Global.np_last(next_attack_state))
				
func process_move():
	if (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) or (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")):
		state_machine.transition_to("Run")
				
func process_dash():
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
	
func shoot():	
	character.get_node("ProjectileSpawn/Weapon").visible = true
	var slash = load("res://characters/character_classes/blade_character/attacks/blade_slash.tscn").instance()
	slash.global_position = character.get_node("ProjectileSpawn/" + str(character.facing).capitalize()).global_position
	
	#if !get_target():
	if true:
		pass
		#if character.facing == "up" or character.facing == "down":
		#	slash.rotation_degrees = 90
	else:
		print("!@#")
		print("slash.rotation_degrees" + str(slash.rotation_degrees))
		slash.rotation_degrees = character.get_node("ProjectileSpawn").rotation_degrees
		print("slash.rotation_degrees" + str(slash.rotation_degrees))
		var target_pos = get_target().global_position
		var spawns = [character.get_node("ProjectileSpawn/Right"),
		character.get_node("ProjectileSpawn/Down"),
		character.get_node("ProjectileSpawn/Left"),
		character.get_node("ProjectileSpawn/Up")]
		var distances = []
		var sp
		for spawn in spawns:
			distances.push_back(spawn.global_position.distance_to(target_pos))
		if distances.find(distances.min()) != -1:
			sp = spawns[distances.find(distances.min())]
		slash.global_position = sp.global_position		
		
	slash.life_time = lengths[0]
	slash.get_node("HitBox").damage = character.weapon().damage
	get_node("/root/world").add_child(slash)
	#character.team.add_child(slash)
	
	slash.add_to_group("player_sword_slash")
