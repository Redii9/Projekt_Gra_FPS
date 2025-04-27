extends CharacterBody3D

@export var health: int = 20
@export var speed: float = 3.0
@export var rotation_speed: float = 5.0
@export var stopping_distance: float = 10.0
@export var gravity: float = 9.8

@export var raycast: RayCast3D
@export var nav_agent: NavigationAgent3D
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var in_game_ui: Control = get_tree().get_first_node_in_group("in_game_ui")

@onready var bullet = load("res://Scenes/enemy_bullet.tscn")

var can_shoot: bool = true
var fire_rate: float = 1.0

@onready var hp_renew: PackedScene = load("res://Scenes/hp_renew.tscn")
@export var drop_hp_chance: float = 0.2

@export var damage_boost: int = 1
@export var kills_need_for_boost: int = 10

func _ready() -> void:
	nav_agent.max_speed = speed
	_update_target_position()

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		in_game_ui.kill_count += 1
		drop_hp_renew()
		queue_free()

func _physics_process(delta: float) -> void:
	_update_target_position()
	if !is_on_floor():
		velocity.y -= gravity * delta
	var distance_to_player = global_position.distance_to(player.global_position)
	velocity.x = 0
	velocity.z = 0
	
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	var look_direction = (player.global_position - global_position).normalized()
	var target_rotation = atan2(look_direction.x, look_direction.z)
	
	# Obrot w strone gracza
	rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	# Ustawienie raycasta na gracza
	raycast.target_position = raycast.to_local(player.global_position)
	
	if distance_to_player <= stopping_distance:
		if raycast.is_colliding() and raycast.get_collider() == player and can_shoot:
			shoot()
	
	if distance_to_player >= stopping_distance:
		velocity = direction * speed
	
	move_and_slide()

func shoot() -> void:
	if !can_shoot:
		return
	shoot_bullet()
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func shoot_bullet() -> void:
	var instance = bullet.instantiate()
	boost_stats(instance)
	get_parent().add_child(instance)
	instance.position = raycast.global_position
	var direction_to_player = (player.global_position - raycast.global_position).normalized()
	instance.look_at(raycast.global_position + direction_to_player, Vector3.UP)

func _update_target_position():
	if player:
		nav_agent.target_position = player.global_position

func drop_hp_renew() -> void:
	if randf() <= drop_hp_chance:
		var hp = hp_renew.instantiate()
		hp.global_transform = global_transform
		get_parent().add_child(hp)

func boost_stats(instance) -> void:
	var boost_multiplier = floor(in_game_ui.kill_count / kills_need_for_boost)
	if boost_multiplier > 0:
		instance.damage += damage_boost * boost_multiplier
