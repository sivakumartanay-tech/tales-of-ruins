extends Control




func _on_start_button_pressed() -> void: # if user press start button teleports to tutorial
	get_tree().change_scene_to_file("res://scenes/control.tscn") 

func _on_quit_pressed() -> void: # if user press quit button, game closes
	get_tree().quit()
