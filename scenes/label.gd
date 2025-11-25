extends Label

@onready var node_2d: Node2D = $"../../Node2D"

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not node_2d.visible:
		$".".text = "Great Job!a"
