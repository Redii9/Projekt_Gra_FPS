extends Control

var kill_count: int = 0
@onready var kills: Label = $VBoxContainer/Label
@onready var player_health: Label = $VBoxContainer/Label2

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	kills.text = str(kill_count)
	player_health.text = str(player.health)
