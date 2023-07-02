extends Node
class_name StatusHolder

var team: Team
var statuses = Global.statuses

var history: String

func _ready():
	add_status("Rage")
	add_status("Sorrow")
	
func add_status(status: String):
	if !statuses.has(status):
		return
	if get_node_or_null(status):
		get_node(status).get_node("Timer").start(get_node(status).life_time)
		return
	var s = load("res://statuses/conditions/" + str(status).to_lower() + ".tscn").instance()
	add_child(s)

func get_status_list():
	return get_children()

func remove_status(status: String):
	#get_node(status).queue_free() #safe deletion
	get_node(status).free() #unsafe deletion
	
func _process(delta: float):
	randomize()
	if Input.is_action_just_pressed("ui_page_down"):
		remove_status(get_status_list()[get_status_list().size() - 1].name)
	if Input.is_action_just_pressed("ui_page_up"):
		add_status(statuses[randi() % 6])

	while get_status_list().size() >= 2:
		history = "Reaction in " + owner.name + " was triggered by " + get_status_list()[0].name
		remove_status(get_status_list()[0].name)
		history += " and " + str(get_status_list()[0].name) + "\n"
		remove_status(get_status_list()[0].name)

