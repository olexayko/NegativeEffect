extends CharacterState

var cooldown = 0.5
var length = 0.25
var speed_multiplier = 2.5

func enter(_msg := {}):
	$Cooldown.start(cooldown)
	$TimeLeft.connect("timeout", self, "goto_run")
	$TimeLeft.start(length)
	#print("DASH " + character.name)

func goto_run():
	state_machine.transition_to("Idle")
	$TimeLeft.disconnect("timeout", self, "goto_run")
	
func physics_update(_delta: float) -> void:
	if character == character.team.get_active_character():
		character.team.move_and_slide(character.direction.normalized() * character.team.speed * speed_multiplier)
	var x = character.direction.x
	var y = character.direction.y
		
	if x == 0 and y == 1: 
		#character.get_node("Sprite").frame = 8
		character.get_node("AnimationPlayer").play("DashDown")
		character.facing = "down"
	elif x == 0 and y == -1:
		#character.get_node("Sprite").frame = 5
		character.get_node("AnimationPlayer").play("DashUp")
		character.facing = "up"
	elif x == 1:
		#character.get_node("Sprite").frame = 7
		character.get_node("AnimationPlayer").play("DashRight")
		character.facing = "right"
	elif x == -1:
		#character.get_node("Sprite").frame = 6
		character.get_node("AnimationPlayer").play("DashLeft")
		character.facing = "left"
	
