extends Node2D

func get_side():
	var scr_width = ProjectSettings.get_setting("display/window/size/width")
	var scr_height = ProjectSettings.get_setting("display/window/size/height")
	var center = Vector2(scr_width / 2, scr_height / 2)
	var mouse = get_viewport().get_mouse_position()
	var point0 = Vector2(375, 0)
	var point1 = Vector2(105, 0)
	var point2 = Vector2(105, 270)
	var point3 = Vector2(375, 270)	
	var sin0 = sin((point0 - center).angle())
	var sin1 = sin((point1 - center).angle())
	var sin2 = sin((point2 - center).angle())
	var sin3 = sin((point3 - center).angle())
	var cos0 = cos((point0 - center).angle())
	var cos1 = cos((point1 - center).angle())
	var cos2 = cos((point2 - center).angle())
	var cos3 = cos((point3 - center).angle())
	var sinus = sin((mouse - center).angle())
	var cosin = cos((mouse - center).angle())
	#print("sin: " + str(sinus))
	#print("cosin: " + str(cosin))
	if cosin <= cos0 and cosin >= cos1 and sinus < 0:
		return "up"
	if cosin <= cos0 and cosin >= cos1 and sinus >= 0:
		return "down"
	if sinus >= sin1 and sinus <= sin3 and cosin <= 0:
		return "left"
	if sinus <= sin2 and sinus >= sin0 and cosin > 0:
		return "right"	
