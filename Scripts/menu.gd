extends Control

var is_credits_open: bool = false
var is_options_open: bool = false

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	if is_options_open:
		return 
	
	is_options_open = true
	 
	var options = load("res://Scenes/options.tscn").instantiate()
	options.add_to_group("options_instances")
	options.menu = self # Przekazanie referencji do menu
	get_tree().root.add_child(options)


func _on_credits_pressed() -> void:
	if is_credits_open:
		return 
	
	is_credits_open = true
	 
	var credits = load("res://Scenes/credits.tscn").instantiate()
	credits.add_to_group("credits_instances")
	credits.menu = self # Przekazanie referencji do menu
	get_tree().root.add_child(credits)
