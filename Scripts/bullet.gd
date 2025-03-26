extends Node3D

var SPEED = 30.0

@export var bullet: MeshInstance3D
@export var raycast: RayCast3D

@export var damage: int = 10

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if !collider.is_in_group("player"):
			bullet.visible = false
			queue_free()
	
	if raycast.is_colliding():
		var target = raycast.get_collider()
		print("Collided with: ", target.name)
		if target.is_in_group("enemy"):
			print("collided")
			target.take_damage(damage)


func _on_timer_timeout() -> void:
	queue_free()
