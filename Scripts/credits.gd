extends Control

var menu: Node = null

func _ready() -> void:
	$Control/VBoxContainer/adrian_credits.text = "[url=https://redii9.itch.io]Adrian Rewera(Redii9)[/url]"
	$Control/VBoxContainer/karol_credits.text = "[url=]Karol Ptak[/url]"
	$Control/VBoxContainer/michal_credits.text = "[url=]Michał Podsiadło[/url]"
	$Control/VBoxContainer/kamil_credits.text = "[url=]Kamil Raczyński[/url]"


func _on_return_pressed() -> void:
	# Usuniecie wszystkich instancji w grupie
	for credits in get_tree().get_nodes_in_group("credits_instances"):
		credits.queue_free()
	
	if menu:
		menu.is_credits_open = false

func _on_redii_credits_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)

func _on_karol_credits_meta_clicked(_meta: Variant) -> void:
	pass # Replace with function body.


func _on_michal_credits_meta_clicked(_meta: Variant) -> void:
	pass # Replace with function body.


func _on_kamil_credits_meta_clicked(_meta: Variant) -> void:
	pass # Replace with function body.
