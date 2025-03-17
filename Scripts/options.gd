extends Control

var menu: Node = null
var config = ConfigFile.new()

@export var fullscreen_button: CheckButton

func _ready() -> void:
	config.load("user://settings.cfg")
	load_fullscreen()

func _on_return_pressed() -> void:
	# Usuniecie wszystkich instancji w grupie
	for options in get_tree().get_nodes_in_group("options_instances"):
		options.queue_free()
	
	if menu:
		menu.is_options_open = false

func load_fullscreen() -> void:
	var fullscreen = config.get_value("video", "fullscreen", false)
	if fullscreen:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	fullscreen_button.button_pressed = fullscreen

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	config.set_value("video", "fullscreen", toggled_on)
	config.save("user://settings.cfg")
