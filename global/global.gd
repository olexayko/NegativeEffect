extends Node

var statuses = ["Greed", "Sorrow", "Fear", "Apathy", "Rage", "Dullness"]

func get_key_bind_name(var string: String):
	return OS.get_scancode_string(InputMap.get_action_list(string)[0].physical_scancode)
			
func set_timeout(secs, object, function):
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = secs
	timer.connect("timeout", object, function)

func pascal_to_snake(string:String)->String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return result.join('')

func reparent_node(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func find_nodes(node: Node, className: String, result: Array) -> void:
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		find_nodes(child, className, result)

func find_by_class(node: Node, className: String):
	var result: Array = []
	find_nodes(node, className, result)
	return result

func np_last(np: NodePath):
	return str(np.get_name(np.get_name_count() - 1))
	
func sum_array(array):
	var sum = 0.0
	for i in array:
		 sum += i
	return sum
