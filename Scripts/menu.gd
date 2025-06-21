extends Control

var is_credits_open: bool = false
var is_options_open: bool = false

var config = ConfigFile.new()

var resolutions: Array[Vector2] = [
	Vector2(1280, 720),
	Vector2(1600, 900),
	Vector2(1920, 1080)
]

var fps_limits: Array = [60, 120, 144, 240, 0]

@onready var BackgroundMusic = $BackgroundMusic

func _ready() -> void:
	config.load("user://settings.cfg")
	load_fullscreen()
	load_resolutions()
	load_fps_limit()
	load_v_sync()
	load_volume_options()
	#sciezka do katalogu testowanie:
	#print("Ścieżka do katalogu user://: ", OS.get_user_data_dir())
	#OS.shell_open(OS.get_user_data_dir())

func _process(_delta: float) -> void:
	if not BackgroundMusic.playing:
		BackgroundMusic.play()

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	if is_options_open:
		return 
	
	is_options_open = true
	 
	var options = load("res://Scenes/UI/options.tscn").instantiate()
	options.add_to_group("options_instances")
	options.resolutions = resolutions
	options.fps_limits = fps_limits
	options.menu = self # Przekazanie referencji do menu
	get_tree().root.add_child(options)


func _on_credits_pressed() -> void:
	if is_credits_open:
		return 
	
	is_credits_open = true
	 
	var credits = load("res://Scenes/UI/credits.tscn").instantiate()
	credits.add_to_group("credits_instances")
	credits.menu = self # Przekazanie referencji do menu
	get_tree().root.add_child(credits)

func load_fullscreen() -> void:
	var fullscreen = config.get_value("video", "fullscreen", false)
	if fullscreen:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED

func load_resolutions() -> void:
	var resolution = config.get_value("video", "resolution", 0)
	if resolution >= 0 and resolution < resolutions.size():
		if !get_window().mode == Window.MODE_FULLSCREEN:
			var selected_resolution = resolutions[resolution]
			get_window().size = selected_resolution
	else:
		if !get_window().mode == Window.MODE_FULLSCREEN:
			var selected_resolution = resolutions[0]
			get_window().size = selected_resolution
		config.set_value("video", "resolution", 0)
		config.save("user://settings.cfg")
	center_window()

func center_window() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var window_size = get_window().size
	
	var new_position = (screen_size - window_size) / 2
	get_window().position = new_position

func load_fps_limit() -> void:
	var fps = config.get_value("video", "fps", 0)
	if fps >= 0 and fps < fps_limits.size():
		var selected_fps = fps_limits[fps]
		Engine.max_fps = selected_fps
	else:
		var selected_fps = fps_limits[0]
		Engine.max_fps = selected_fps
		config.set_value("video", "fps", 0)
		config.save("user://settings.cfg")

func load_v_sync() -> void:
	var v_sync = config.get_value("video", "v_sync", true)
	if v_sync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func load_volume_options():
	var saved_volume = config.get_value("master_volume", "Master", 0.5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(saved_volume))
