extends CharacterState

var cooldown = 0.5
var length = 0.125
var speed_multiplier = 3

func enter():
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
		character.get_node("AnimationPlayer").play("DashDown")
		character.facing = "down"
	elif x == 0 and y == -1:
		character.get_node("AnimationPlayer").play("DashUp")
		character.facing = "up"
	elif x == 1:
		character.get_node("AnimationPlayer").play("DashRight")
		character.facing = "right"
	elif x == -1:
		character.get_node("AnimationPlayer").play("DashLeft")
		character.facing = "left"
	
