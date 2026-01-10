extends Node2D
@onready var area_2d: Area2D = $Area2D
@onready var node_2d: Node2D = $"../Node2D"
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


func _ready() -> void:
	$".".position.x  = 234
	$".".position.y = -238
	area_2d.monitoring = false
	collision_shape_2d.disabled = true #turns off when game starts


func _process(_delta: float) -> void:
	if node_2d == null: #checks if the enemy is dead
		tp_level1()  #allows player to enter




func tp_level1(): # turn on monitoring and tps player to level 1
	area_2d.monitoring = true
	collision_shape_2d.disabled = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn") # Teleports player to level 1
 # Replace with function body.
