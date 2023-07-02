extends Button

func _ready() -> void:
	connect("pressed", self, "run_game")
	
func run_game():
	get_tree().change_scene("res://world.tscn")
