extends CanvasLayer

var team: Team

func _ready() -> void:
	yield(owner, "ready")
	team = owner as Team
	assert(team != null)
	$DebugLabel.visible = OS.get_processor_name() == "Intel(R) Core(TM) i5-9600KF CPU @ 3.70GHz"
	
func debug_label_update() -> void:
	if Input.is_action_just_pressed("f1"):
		$DebugLabel.visible = !$DebugLabel.visible
	var string = ""
	string += "OS.get_static_memory_usage() = " + str(OS.get_static_memory_usage() / 1000000) + " mb\n"
	string += "Engine.get_frames_per_second() = " + str(Engine.get_frames_per_second()) + "\n"
	$DebugLabel.text = string

func update_hp_bar():
	$TeamHpBar/TextureProgress.value = team.hp / float(team.max_hp) * 100
	
func update():
	clear_skill_panel()
	update_skill_panel()
	update_hp_bar()

func update_inactive_character_skill_line(line_idx, char_idx):
	var character = team.get_character(char_idx)
	var ui = get_node("Skills/InactiveCharacter" + str(line_idx))
	assert((int(char_idx) <= 4 and int(char_idx) >= 1) and (int(line_idx) >= 1 and int(line_idx) <= 3))
	var common_skill = character.get_node("StateMachine").get_node(Global.np_last(character.common_skill))
	var ultimate_skill = character.get_node("StateMachine").get_node(Global.np_last(character.ultimate_skill))
	
	ui.get_node("Label").text = str(character.name)
	ui.get_node("Common/Label").text = str(common_skill.energy_cost)
	ui.get_node("Ultimate/Label").text = str(ultimate_skill.energy_cost)
	
	ui.get_node("Common/Sprite").texture_under = common_skill.icon_under_16
	ui.get_node("Common/Sprite").texture_progress = common_skill.icon_progress_16
	#print(common_skill)
	#print(common_skill.energy)
	#print(common_skill.energy_cost)
	
	ui.get_node("Common/Sprite").value = common_skill.energy / float(common_skill.energy_cost) * 100
	
	ui.get_node("Ultimate/Sprite").texture_under = ultimate_skill.icon_under_16
	ui.get_node("Ultimate/Sprite").texture_progress = ultimate_skill.icon_progress_16
	ui.get_node("Ultimate/Sprite").value = ultimate_skill.energy / float(ultimate_skill.energy_cost) * 100
	
#	ui.get_node("Icon/Sprite").texture = character.icon_32
	
func update_active_character_skill_line():
	var character = team.get_active_character()
	var ui = $Skills/ActiveCharacter
	var common_skill = character.get_node("StateMachine").get_node(Global.np_last(character.common_skill))
	var ultimate_skill = character.get_node("StateMachine").get_node(Global.np_last(character.ultimate_skill))
	
	ui.get_node("Label").text = str(character.name)
	ui.get_node("Common/Label").text = str(common_skill.energy_cost)
	ui.get_node("Ultimate/Label").text = str(ultimate_skill.energy_cost)
	
	ui.get_node("Common/Sprite").texture_under = common_skill.icon_under_32
	ui.get_node("Common/Sprite").texture_progress = common_skill.icon_progress_32
	ui.get_node("Common/Sprite").value = common_skill.energy / common_skill.energy_cost * 100
	
	
	ui.get_node("Ultimate/Sprite").texture_under = ultimate_skill.icon_under_32
	ui.get_node("Ultimate/Sprite").texture_progress = ultimate_skill.icon_progress_32
	ui.get_node("Ultimate/Sprite").value = ultimate_skill.energy / ultimate_skill.energy_cost * 100
	
#	ui.get_node("Icon/Sprite").texture = character.icon_64
	
func update_skill_panel():
	update_active_character_skill_line()
	var inactive_characters = team.get_inactive_characters()
	var idxs = []
	var i = next(team.current_character_id)
	while i != team.current_character_id:
		if team.get_character(i):
			idxs.append(i)
		i = next(i)
	for idx in range(1, inactive_characters.size() + 1):
		update_inactive_character_skill_line(idx, idxs[idx - 1])

func next(var i: int):
	assert(i <= 4 and i >= 1)
	if i == 4:
		return 1
	else:
		return i + 1
	
func _process(delta: float) -> void:
	debug_label_update()
	update()
	
func clear_skill_panel():
	var sprites = []
	sprites.append_array(Global.find_by_class($Skills/ActiveCharacter, "TextureProgress"))
	sprites.append_array(Global.find_by_class($Skills/InactiveCharacter1, "TextureProgress"))
	sprites.append_array(Global.find_by_class($Skills/InactiveCharacter2, "TextureProgress"))
	sprites.append_array(Global.find_by_class($Skills/InactiveCharacter3, "TextureProgress"))
	var labels = []
	labels.append_array(Global.find_by_class($Skills/ActiveCharacter, "Label"))
	labels.append_array(Global.find_by_class($Skills/InactiveCharacter1, "Label"))
	labels.append_array(Global.find_by_class($Skills/InactiveCharacter2, "Label"))
	labels.append_array(Global.find_by_class($Skills/InactiveCharacter3, "Label"))
	
	for label in labels:
		label.text = ""
		
	for sprite in sprites:
		sprite.texture_under = null 	
		sprite.texture_over = null 
		sprite.texture_progress = null 
		

