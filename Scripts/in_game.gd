extends Control

var kill_count: int = 0
@onready var kills: Label = $Label

func _process(_delta: float) -> void:
	kills.text = str(kill_count)
	
