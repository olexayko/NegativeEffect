extends KinematicBody2D
class_name Character

export(NodePath) var common_skill
export(NodePath) var ultimate_skill
export(NodePath) var attack
export(PackedScene) var default_weapon
export(String, "Blade", "OneHanded", "Blunt", "Shotgun", "Rifle", "Pistol") var attack_type
export(String, "Apathy", "Rage", "Dullness", "Sorrow", "Greed", "Fear") var condition_type
export(String, "Rare", "Epic", "Legendary") var rarity
var energy
var energy_regeneration = 0.2

var team
var direction = Vector2(1, 0)
var facing = "down"

func _ready():
	$ProjectileSpawn/Weapon.visible = false
	if default_weapon != null:
		var w = default_weapon.instance()
		yield(get_parent().get_parent(), "ready")
		#print("&", self.team)
		w.team = self.team
		$ProjectileSpawn/Weapon.add_child(w)

func get_skills():
	var cs = get_node("StateMachine/" + Global.np_last(common_skill)) 
	var us = get_node("StateMachine/" + Global.np_last(ultimate_skill)) 
	return [cs, us]
	
func weapon():
	if $ProjectileSpawn/Weapon.get_child_count():
		return $ProjectileSpawn/Weapon.get_child(0)
func brain():
	if $Equipment/Brain.get_child_count():
		return $Equipment/Brain.get_child(0)
func nervous_system():
	if $Equipment/NervousSystem.get_child_count():
		return $Equipment/NervousSystem.get_child(0)
func operating_system():
	if $Equipment/OperatingSystem.get_child_count():
		return $Equipment/OperatingSystem.get_child(0)
func skeleton():
	if $Equipment/Skeleton.get_child_count():
		return $Equipment/Skeleton.get_child(0)

	
func _process(_delta):
	for skill in get_skills():
		var multiplier = 0.5
		if skill: 
			if team.get_active_character() == self:
				multiplier = 1
			skill.energy = min(skill.energy_cost, skill.energy + energy_regeneration * multiplier)
			
	var state = get_node("StateMachine").state

	#if !OS.get_processor_name() == "Intel(R) Core(TM) i5-9600KF CPU @ 3.70GHz":
		#	get_node("Label").text = text


