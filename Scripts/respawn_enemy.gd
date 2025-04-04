extends Node3D

@onready var enemy_scene: Array[PackedScene] = [load("res://Scenes/enemy.tscn"),
load("res://Scenes/enemy_fast.tscn"), load("res://Scenes/enemy_range.tscn")]
@export var max_enemies = 10
@export var spawn_markers: Array[Marker3D] = []

func spawn_enemy() -> void:
	var alive_enemies = get_tree().get_nodes_in_group("enemy").size()
	if alive_enemies < max_enemies:
		var random_enemy = enemy_scene.pick_random()
		var random_marker = spawn_markers.pick_random()
		var enemy = random_enemy.instantiate()
		enemy.global_transform = random_marker.global_transform
		get_parent().add_child(enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()
