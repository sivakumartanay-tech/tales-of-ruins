extends Area2D
@onready var player_1: CharacterBody2D = $Player1
const SPEED = 300
var chasing = false
var player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hi") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		chasing = true
		


func _on_body_exited(_body: Node2D) -> void:
	chasing = false
	
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if player:
		var direction = (player_1.global_position - global_position).normalized()
		velocity = direction * SPEED
		global_position += velocity * delta
