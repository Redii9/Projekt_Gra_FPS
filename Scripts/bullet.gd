extends Node3D

var SPEED = 30.0

@export var bullet: MeshInstance3D
@export var raycast: RayCast3D

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if !collider.is_in_group("player"):
			bullet.visible = false
			queue_free()


func _on_timer_timeout() -> void:
	queue_free()
