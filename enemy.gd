extends Node2D
@onready var player_1: CharacterBody2D = $"../Player1"
const SPEED = 100
var chasing = false
var player = null
var chase_range = 150
var velocity = Vector2.ZERO
var is_moving = false
@onready var hitbox: Area2D = $Hitbox
@onready var tutorial_enemy: AnimatedSprite2D = $"Tutorial Enemy"

func _ready() -> void:
	player = player_1

func _process(_delta: float) -> void:
	if is_moving:
		tutorial_enemy.play("run")
	else:
		tutorial_enemy.play("idle")




func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player_1.global_position)

	if distance < 50:
		velocity = Vector2.ZERO
		return
	
	
	

	if distance <= chase_range and hitbox.enemy_health != 0 and not distance <= 0:
		is_moving = true
		var direction = (player_1.global_position - global_position).normalized()
		velocity = direction * SPEED
		global_position += velocity * delta
		if direction.x < 0:
			tutorial_enemy.flip_h = true
		else:
			tutorial_enemy.flip_h = false

	else:
		is_moving = false
