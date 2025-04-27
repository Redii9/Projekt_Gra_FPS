extends CharacterBody3D

@export var health: int = 20
@export var enemy_damage: int = 5
@export var damage_cooldown: float = 0.5
@export var speed: float = 3.0
@export var rotation_speed: float = 5.0
var player_in_area = null
#var can_deal_damage: bool = true
@export var nav_agent: NavigationAgent3D
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var in_game_ui: Control = get_tree().get_first_node_in_group("in_game_ui")

@onready var hp_renew: PackedScene = load("res://Scenes/hp_renew.tscn")
@export var drop_hp_chance: float = 0.2

@export var hp_boost: int = 10
@export var kills_need_for_boost: int = 10

func _ready() -> void:
	boost_stats()
	nav_agent.max_speed = speed
	_update_target_position()

func _physics_process(delta: float) -> void:
	_update_target_position()
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized() # obliczanie kierunku normalized zmiena wektor na wersor
	
	if direction.length() > 0.1: # Tylko jesli się porusza
		var target_rotation = atan2(direction.x, direction.z) # Kierunek ruchu
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	velocity = direction * speed
	
	move_and_slide()

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		in_game_ui.kill_count += 1
		drop_hp_renew()
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

func drop_hp_renew() -> void:
	if randf() <= drop_hp_chance:
		var hp = hp_renew.instantiate()
		hp.global_transform = global_transform
		get_parent().add_child(hp)

func boost_stats() -> void:
	var boost_multiplier = floor(in_game_ui.kill_count / kills_need_for_boost)
	if boost_multiplier > 0:
		health += hp_boost * boost_multiplier
