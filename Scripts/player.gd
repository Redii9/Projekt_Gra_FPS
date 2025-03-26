extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_force: float = 5.0
@export var gravity: float = 9.8
@export var mouse_sensitivity: float = 0.002

@export var damage: int = 10
@export var fire_rate: float = 0.1
@export var max_distance: float = 100.0

var can_shoot: bool = true

var bullet = load("res://Scenes/bullet.tscn")
var instance

@onready var raycast: RayCast3D = $Head/Camera3D/Raycast/RayCast3D
@onready var gun_barrel: RayCast3D = $Head/Camera3D/Gun/RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	raycast.target_position = Vector3(0, 0, -max_distance)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Head/Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Head/Camera3D.rotation_degrees.x = clamp($Head/Camera3D.rotation_degrees.x, -90, 90)

func _physics_process(delta):
	movement(delta)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		shoot_bullet()
	
	move_and_slide()

func movement(delta) -> void:
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		input_dir -= transform.basis.z
	if Input.is_action_pressed("backward"):
		input_dir += transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir -= transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += transform.basis.x
	
	input_dir = input_dir.normalized()
	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
	else:
		velocity.y -= gravity * delta

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

func shoot_bullet() -> void:
	instance = bullet.instantiate()
	instance.position = gun_barrel.global_position
	instance.transform.basis = gun_barrel.global_transform.basis
	get_parent().add_child(instance)
