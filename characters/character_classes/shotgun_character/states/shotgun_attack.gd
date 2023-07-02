extends CharacterState

var direction

func enter() -> void:
	#print("Shotgun Attack " + character.name)
	character.get_node("ProjectileSpawn/Weapon").visible = true
	character.team.is_attacking = true
	if get_target():
		character.get_node("ProjectileSpawn").rotation_degrees = rad2deg((get_target().global_position - character.team.global_position).angle())
	
var time: float = 0
var bullets = 3
var pre_delay = 0.25
var after_delay = 0.75
var shooted = false

func physics_update(_delta: float) -> void:
	if shooted == false and time >= pre_delay:
		shoot(12)
		shoot(4)
		shoot(-4)
		shoot(-12)
		shooted = true
		
	if Input.is_action_pressed("dash") and !state_machine.get_node("Dash/Cooldown").get_time_left():
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
	if time >= pre_delay + after_delay:
		state_machine.transition_to("Idle")	
		
func exit():
	time = 0
	shooted = false
	character.get_node("ProjectileSpawn/Weapon").visible = false
	character.team.is_attacking = false
	character.get_node("ProjectileSpawn").rotation_degrees = 0
	
var Bullet = preload("res://characters/character_classes/shotgun_character/attacks/bullet_shotgun.tscn")
	
func shoot(degrees):
	var bullet = Bullet.instance()

	bullet.global_position = character.get_node("ProjectileSpawn/" + str(character.facing).capitalize()).global_position
	#bullet.rotation = character.get_node("ProjectileSpawn").rotation
	bullet.damage = character.weapon().damage
	
	bullet.linear_velocity = Vector2(bullet.speed, 0)
	#.rotated(character.get_node("ProjectileSpawn").rotation)
	
	if !character.get_node("ProjectileSpawn").rotation_degrees:
		if character.facing == "up":
			bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(-90))
		
		elif character.facing == "down":
			bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(90))
		
		elif character.facing == "right":
			bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(0))
		
		elif character.facing == "left":
			bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(180))
	else:
		bullet.linear_velocity = bullet.linear_velocity.rotated(character.get_node("ProjectileSpawn").rotation)
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
			print(distances)
			sp = spawns[distances.find(distances.min())]
			print(sp)
		bullet.global_position = sp.global_position		
	bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(degrees))
	get_node("/root/world").add_child(bullet)

