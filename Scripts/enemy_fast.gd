extends CharacterBody3D

@export var health: int = 20
@export var enemy_damage: int = 5
@export var damage_cooldown: float = 0.3
@export var current_speed: float = 2.0
@export var max_speed: float = 8.0
@export var acceleration: float = 1.0
@export var rotation_speed: float = 8.0

var player_in_area = null
@export var nav_agent: NavigationAgent3D
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	nav_agent.max_speed = max_speed
	_update_target_position()

func _physics_process(delta: float) -> void:
	_update_target_position()
	
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	if direction.length() > 0.1: # Tylko jesli się porusza
		var target_rotation = atan2(direction.x, direction.z) # Kierunek ruchu
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	# Zwiekszenie predkosci wraz z czasem
	current_speed = min(current_speed + acceleration * delta, max_speed)
	velocity = direction * current_speed
	move_and_slide()

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		player_in_area = null
		queue_free()

func _on_damage_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and player_in_area == null:
		player_in_area = body
		deal_damage()

func _on_damage_area_body_exited(body: Node3D) -> void:
	if body == player_in_area:
		player_in_area = null

func deal_damage() -> void:
	while player_in_area != null:
		player_in_area.take_player_damage(enemy_damage)
		await get_tree().create_timer(damage_cooldown).timeout

func _update_target_position():
	if player:
		nav_agent.target_position = player.global_position
