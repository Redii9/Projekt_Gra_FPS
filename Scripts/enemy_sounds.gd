extends Node3D

@onready var enemy_death = $Enemy_Death

func _ready() -> void:
	enemy_death.play()

func _process(_delta: float) -> void:
	if !enemy_death.playing:
		queue_free()
