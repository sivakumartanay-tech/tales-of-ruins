extends Label

@onready var node_2d: Node2D = $"../../Node2D"


func _process(_delta: float) -> void:
	if node_2d == null: # checks if enemy is dead
		$".".text = "Great Job! Head to trough the 
door at the top!" #changes text if enemy is dead
