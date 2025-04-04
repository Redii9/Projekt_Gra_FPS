extends Node3D

var SPEED = 10.0

@export var bullet: MeshInstance3D
@export var raycast: RayCast3D
@export var hit_particles: GPUParticles3D

@export var damage: int = 10

var has_hit = false

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	
	process_hit()


func _on_timer_timeout() -> void:
	queue_free()

func process_hit() -> void:
	if raycast.is_colliding() and !has_hit:
		var target = raycast.get_collider()
		if !is_instance_valid(target):
			return
		if !target.is_in_group("enemy"):
			print("Collided with: ", target.name)
			if target.is_in_group("player"):
				target.take_player_damage(damage)
			bullet.visible = false
			hit_particles.restart()
			has_hit = true
			await get_tree().create_timer(0.4).timeout
			queue_free()
