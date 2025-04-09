extends Node3D

@onready var enemy_scene: Array[PackedScene] = [load("res://Scenes/enemy.tscn"),
load("res://Scenes/enemy_fast.tscn"), load("res://Scenes/enemy_range.tscn")]
@export var max_enemies = 10
@export var spawn_markers: Array[Marker3D] = []

func spawn_enemy() -> void:
	var alive_enemies = get_tree().get_nodes_in_group("enemy").size()
	if alive_enemies < max_enemies:
		var available_markers = []
		for marker in spawn_markers:
			var area = marker.get_node("Area3D")
			if not is_enemies_in_area(area):
				available_markers.append(marker)
		
		if available_markers.is_empty():
			return
		
		var random_enemy = enemy_scene.pick_random()
		var random_marker = available_markers.pick_random()
		var enemy = random_enemy.instantiate()
		enemy.global_transform = random_marker.global_transform
		get_parent().add_child(enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()

func is_enemies_in_area(area: Area3D) -> bool:
	for body in area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			return true
	return false
