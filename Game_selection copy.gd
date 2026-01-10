extends Control

var character_scene: PackedScene = null



func _on_player_2_pressed() -> void:
	Global.chosen_character = preload("res://scenes/player_2.tscn")
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	# saves player 2 scene when player 2 button pressed


func _on_player_1_pressed() -> void:
	Global.chosen_character = preload("res://scenes/character_1.tscn")
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	# saves player 1 scene when player 1 button is pressed
