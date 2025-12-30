extends Node2D


var camera = Camera2D.new() #camera node

func _ready() -> void:
	if Global.chosen_character: # selected character
		camera.zoom = Vector2(1.7,1.7) # camera zoom
		var character = Global.chosen_character.instantiate() # instatiated selected character 
		add_child(character) # character node
		character.add_child(camera) # camera 
		character.position = Vector2(0,0) # character spawn
