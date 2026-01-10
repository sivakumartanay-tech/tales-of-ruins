extends Node2D

var camera = Camera2D.new() #camera node

func _ready() -> void:
	if Global.chosen_character: # selected character
		Global.player_health = 100
		camera.zoom = Vector2(1.9,1.9) # camera zoom
		var character = Global.chosen_character.instantiate() # instatiated selected character 
		add_child(character) # character node
		character.add_child(camera) # camera 
		character.position = Vector2(-1,-5) # character spawn


func _process(_delta: float) -> void:
	check_enemies()


func check_enemies():
	if get_tree().get_nodes_in_group("enemys").is_empty():
		get_tree().change_scene_to_file("res://scenes/level_1.tscn") # Teleports player to level 1
