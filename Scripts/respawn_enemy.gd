extends Node3D

@export var enemy_scene: PackedScene
@export var max_enemies = 10
@export var spawn_markers: Array[Marker3D] = []

func spawn_enemy() -> void:
	var alive_enemies = get_tree().get_nodes_in_group("enemy").size()
	if alive_enemies <= max_enemies:
		var enemy = enemy_scene.instantiate()
		var random_marker = spawn_markers.pick_random()
		enemy.global_transform = random_marker.global_transform
		get_parent().add_child(enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()
