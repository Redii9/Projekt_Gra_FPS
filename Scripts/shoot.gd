extends Node3D

@export var damage: int = 10
@export var fire_rate: float = 0.5
@export var max_distance: float = 100.0

var can_shoot: bool = true

@export var raycast: RayCast3D

func _ready() -> void:
	raycast.target_position = Vector3(0, 0, -max_distance)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
	

func shoot() -> void:
	if !can_shoot:
		return
	
	print("shooted")
	if raycast.is_colliding():
		var target = raycast.get_collider()
		print("Collided with: ", target.name)
		if target.is_in_group("enemy"):
			print("collided")
			target.take_damage(damage)
	
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
