extends Control



func _on_respawn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn") # takes user to tutorial

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn") # takes player to title screen
