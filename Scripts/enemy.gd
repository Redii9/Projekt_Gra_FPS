extends CharacterBody3D

var health: int = 20

func take_damage(damage: int) -> void:
	health -= damage
	print("took damage")
	if health <= 0:
		queue_free()
