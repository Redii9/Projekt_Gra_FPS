extends Control

func _on_menu_pressed() -> void:
	for end_screen in get_tree().get_nodes_in_group("end_screen_instances"):
		end_screen.queue_free()
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
