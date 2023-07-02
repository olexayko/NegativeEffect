extends CharacterState

export(NodePath) var next_attack_state
#export(Array, float) var lengths = [0.4, 0.1, 0, 0.2, 0.5, 0.5]
var timings = [0.1, 0.3, 0.1, 0.1, 0.1, 0.5, 0.7]
#var time: float = 0
var bullets_shooted = 0

var break_by_dash = false
var break_by_move = false
var break_by_abilities = false
var break_by_attack = false

var current_moving_power = 0
var moving_power_1 = 50
var moving_power_2 = 75

var step

func enter() -> void:
	character.team.is_attacking = true
	bullets_shooted = 0
	break_by_attack = false
	break_by_dash = false
	break_by_move = false
	break_by_abilities = false
	current_moving_power = 0
	var iter = get_script().get_path()[-4]
	if MeleeAttackCoords.get_side() == "left":
		character.direction = Vector2(-1, 0)
		character.facing = "left"
		character.get_node("AnimationPlayer").play("AttackLeft" + str(iter))
		character.weapon().get_node("AnimationPlayer").play("AttackLeft" + str(iter))
	if MeleeAttackCoords.get_side() == "right":
		character.direction = Vector2(1, 0)
		character.facing = "right"
		character.get_node("AnimationPlayer").play("AttackRight" + str(iter))
		character.weapon().get_node("AnimationPlayer").play("AttackRight" + str(iter))
	if MeleeAttackCoords.get_side() == "down":
		character.direction = Vector2(0, 1)
		character.facing = "down"
		character.get_node("AnimationPlayer").play("AttackDown" + str(iter))
		character.weapon().get_node("AnimationPlayer").play("AttackDown" + str(iter))
	if MeleeAttackCoords.get_side() == "up":
		character.direction = Vector2(0, -1)
		character.facing = "up"
		character.get_node("AnimationPlayer").play("AttackUp" + str(iter))
		character.weapon().get_node("AnimationPlayer").play("AttackUp" + str(iter))
	character.get_node("ProjectileSpawn/Weapon").visible = true
	print(name + " enter")
	for i in range(0, 7):
		get_node("Timer" + str(i)).start(Global.sum_array(timings.slice(0, i)))
		#print(Global.sum_array(timings.slice(0, i)))
		get_node("Timer" + str(i)).connect("timeout", self, "timeout_" + str(i))
	"""
	if get_target():
		character.get_node("ProjectileSpawn").rotation_degrees = rad2deg((get_target().global_position - character.team.global_position).angle())
		print(character.get_node("ProjectileSpawn").rotation_degrees)
	"""
	current_moving_power = moving_power_1
	
func timeout_0():
	current_moving_power = 0
	print(name + " %0")
	step = 0
	
func timeout_1():
	current_moving_power = moving_power_2
	shoot()
	bullets_shooted += 1
	print(name + " %1")
	step = 1

func timeout_2():
	current_moving_power = 0
	print(name + " %2")
	step = 2

func timeout_3():
	print(name + " %3")
	break_by_dash = true
	step = 3
	
func timeout_4():
	break_by_attack = true
	print(name + " %4")
	step = 4

func timeout_5():
	break_by_attack = false
	break_by_move = true
	print(name + " %5")
	step = 5
	
func timeout_6():
	break_by_attack = false
	print(name + " %6")
	step = 6
	state_machine.transition_to("Idle")
	
func exit():
	for i in range(0, 7):
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
	for i in get_tree().get_nodes_in_group("player_blunt_slash"):
		i.queue_free()
	character.get_node("ProjectileSpawn/Weapon").visible = false

func physics_update(_delta: float) -> void:
	process_moving()
	#character.get_node("Label").text = "step " + str(step)
	character.get_node("Label").text = "\nspeed = " + str(current_moving_power)
	if break_by_dash:
		process_dash()
	if break_by_abilities:
		process_skills()
	if break_by_move:
		process_move()
	if break_by_attack:
		process_combo_attack()

func process_moving():
	if not current_moving_power:
		return
	var deg = character.get_node('ProjectileSpawn').rotation_degrees
	if deg == 0:
		character.team.move_and_slide(character.direction.normalized() * current_moving_power)
	else:
		character.team.move_and_slide((Vector2(1, 0) * current_moving_power).rotated(deg2rad(deg)))
	
func process_combo_attack():
	if Input.is_action_just_pressed("attack"):
		if next_attack_state:
			state_machine.transition_to(Global.np_last(next_attack_state))
				
func process_move():
	if (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) or (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")):
		state_machine.transition_to("Run")

func shoot():	
	var slash = load("res://characters/character_classes/blunt_character/attacks/blunt_slash.tscn").instance()
	
	#if !get_target():
	if true:
		#if character.facing == "up" or character.facing == "down":
		#	slash.rotation_degrees = 90
		pass
	"""
	else:
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
	"""
	var iter = get_script().get_path()[-4]
	slash.life_time = timings[2] + timings[3]
	slash.get_node("HitBox").damage = character.weapon().damage
	
	slash.get_node("AnimationPlayer").play("Attack" + character.facing.capitalize() + str(iter))
	#print("play Attack" + character.facing.capitalize() + str(iter))
	character.get_node("ProjectileSpawn/" + character.facing.capitalize()).add_child(slash)
	
	slash.add_to_group("player_blunt_slash")

