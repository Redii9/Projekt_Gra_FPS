extends Control

@onready var in_game_ui: Control = get_tree().get_first_node_in_group("in_game_ui")
@onready var kills: Label = $VBoxContainer/kills

func _ready() -> void:
	kills.text = str(in_game_ui.kill_count)

func _on_menu_pressed() -> void:
	for end_screen in get_tree().get_nodes_in_group("end_screen_instances"):
		end_screen.queue_free()
	
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")


func _on_retry_pressed() -> void:
	for end_screen in get_tree().get_nodes_in_group("end_screen_instances"):
		end_screen.queue_free()
	
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
