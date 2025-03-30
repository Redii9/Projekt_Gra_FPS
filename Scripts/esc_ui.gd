extends Control

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		_on_return_pressed()

func _on_menu_pressed() -> void:
	for esc in get_tree().get_nodes_in_group("esc_ui_instances"):
		esc.queue_free()
	
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")


func _on_return_pressed() -> void:
	for esc in get_tree().get_nodes_in_group("esc_ui_instances"):
		esc.queue_free()
	var main_nodes = get_tree().get_nodes_in_group("game")
	for node in main_nodes:
		node.process_mode = Node.PROCESS_MODE_INHERIT
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
