extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/survivor_game.tscn")


func _on_upgrades_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/upgrades_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
