extends Node3D

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@export var add_hp: int = 10
@export var max_health: int = 100

func _on_renew_body_entered(body: Node3D) -> void:
	if body == player:
		for i in add_hp:
			if player.health < max_health:
				player.health += 1
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
