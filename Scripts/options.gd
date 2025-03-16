extends Control

var menu: Node = null


func _on_return_pressed() -> void:
	# Usuniecie wszystkich instancji w grupie
	for options in get_tree().get_nodes_in_group("options_instances"):
		options.queue_free()
	
	if menu:
		menu.is_options_open = false
