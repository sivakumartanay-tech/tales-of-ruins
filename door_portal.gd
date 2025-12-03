extends Node2D
@onready var area_2d: Area2D = $Area2D
@onready var node_2d: Node2D = $"../Node2D"


func _ready() -> void:
	area_2d.monitoring = false #turns off when game starts


func _process(_delta: float) -> void:
	if not node_2d.visible: #checks if the enemy is dead
		area_2d.monitoring = true #allows player to enter

func _on_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn") # Teleports player to level 1
