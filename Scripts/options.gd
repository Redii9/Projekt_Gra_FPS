extends Control

var menu: Node = null
var config = ConfigFile.new()

@export var fullscreen_button: CheckButton
@export var resolutions_button: OptionButton
@export var fps_button: OptionButton
@export var v_sync_button: CheckButton

var resolutions: Array[Vector2] = []
var fps_limits: Array = []

func _ready() -> void:
	config.load("user://settings.cfg")
	load_fullscreen()
	load_resolutions()
	load_fps_limit()
	load_v_sync()

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
		load_resolutions()
	config.set_value("video", "fullscreen", toggled_on)
	config.save("user://settings.cfg")

func load_resolutions() -> void:
	var resolution = config.get_value("video", "resolution", 0)
	resolutions_button.selected = resolution
	set_resolution(resolution)

func set_resolution(index: int) -> void:
	var selected_resolution = resolutions[index]
	if get_window().mode == Window.MODE_FULLSCREEN:
		config.set_value("video", "resolution", index)
		config.save("user://settings.cfg")
		return
	get_window().mode = Window.MODE_WINDOWED
	get_window().size = selected_resolution
	
	center_window()
	
	config.set_value("video", "resolution", index)
	config.save("user://settings.cfg")

func center_window() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var window_size = get_window().size
	
	var new_position = (screen_size - window_size) / 2
	get_window().position = new_position

func _on_resolutions_item_selected(index: int) -> void:
	set_resolution(index)

func load_fps_limit() -> void:
	var fps = config.get_value("video", "fps", 0)
	fps_button.selected = fps
	set_fps_limit(fps)

func set_fps_limit(index: int) -> void:
	var selected_fps = fps_limits[index]
	Engine.max_fps = selected_fps
	config.set_value("video", "fps", index)
	config.save("user://settings.cfg")

func _on_fps_item_selected(index: int) -> void:
	set_fps_limit(index)

func load_v_sync() -> void:
	var v_sync = config.get_value("video", "v_sync", true)
	v_sync_button.button_pressed = v_sync
	set_v_sync(v_sync)
	print("Loaded, ", v_sync)

func set_v_sync(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("Enabled")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("Disabled")
	config.set_value("video", "v_sync", toggled_on)
	config.save("user://settings.cfg")

func _on_v_sync_toggled(toggled_on: bool) -> void:
	set_v_sync(toggled_on)
