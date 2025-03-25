extends Node3D

var SPEED = 100.0

@export var bullet: MeshInstance3D
@export var raycast: RayCast3D

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
