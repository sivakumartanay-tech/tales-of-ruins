extends CanvasLayer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if visible:
			unpause()
		else:
			pausing()

func _ready():
	
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false

func pausing():
	visible = true
	get_tree().paused = true

func unpause():
	get_tree().paused = false
	visible = false
	

func _on_resume_pressed() -> void:
	print("pressed")
	unpause() # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().paused = false # Replace with function body.
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
