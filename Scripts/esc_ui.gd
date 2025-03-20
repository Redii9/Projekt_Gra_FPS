extends Control


func _on_menu_pressed() -> void:
	for esc in get_tree().get_nodes_in_group("esc_ui_instances"):
		esc.queue_free()
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_return_pressed() -> void:
	for esc in get_tree().get_nodes_in_group("esc_ui_instances"):
		esc.queue_free()
	get_tree().root.get_node("Main").process_mode = Node.PROCESS_MODE_INHERIT
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
