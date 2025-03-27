extends Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		apply_esc_ui()

func apply_esc_ui() -> void:
	var esc_ui = get_tree().get_nodes_in_group("esc_ui_instances")
	
	if esc_ui:
		for esc in get_tree().get_nodes_in_group("esc_ui_instances"):
			esc.queue_free()
		var main_nodes = get_tree().get_nodes_in_group("game")
		for node in main_nodes:
			node.process_mode = Node.PROCESS_MODE_INHERIT
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		esc_ui = load("res://Scenes/esc_ui.tscn").instantiate()
		esc_ui.add_to_group("esc_ui_instances")
		get_tree().root.add_child(esc_ui)
		var main_nodes = get_tree().get_nodes_in_group("game")
		for node in main_nodes:
			node.process_mode = Node.PROCESS_MODE_DISABLED
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
