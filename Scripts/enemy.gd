extends CharacterBody3D

@export var health: int = 20
@export var enemy_damage: int = 5
@export var damage_cooldown: float = 0.5
var player_in_area = null
#var can_deal_damage: bool = true

func _physics_process(_delta: float) -> void:
	pass

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
