extends Node2D


var camera = Camera2D.new()

func _ready() -> void:
	if Global.chosen_character:
		camera.zoom = Vector2(1.7,1.7)
		var character = Global.chosen_character.instantiate() 
		add_child(character)
		character.add_child(camera)
		character.position = Vector2(0,0)
