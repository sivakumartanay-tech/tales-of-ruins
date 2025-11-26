extends Area2D
@onready var bad_guy: AnimatedSprite2D = $"../Tutorial Enemy"
@onready var player_1: CharacterBody2D = $"../../Player1"
@onready var hitbox: Area2D = $"."
@onready var attack_hitbox: CollisionShape2D = $"AnimatedSprite2D/Area2D/Attack hitbox"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var enemy_health = 50
var is_not_moving = true
var player_alive = true

func _ready() -> void:
	bad_guy.flip_h = true


func _on_body_entered(_body: Node2D) -> void:
	while body_entered and player_alive:
		if _body.is_in_group("Player"):
			_body.health -= 10
			await get_tree().create_timer(1.0).timeout
		if _body.health == 0:
			break

func _process(_delta: float) -> void:
	if is_not_moving:
		bad_guy.play("idle")
	if enemy_health <= 0:
		hitbox.monitoring = false
		collision_shape_2d.disabled = true
		bad_guy.play("death")
		await bad_guy.animation_finished
		get_parent().visible = false
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"):
		is_not_moving = false
		enemy_health -= 10 
		print(enemy_health) 
		bad_guy.play("hit")
		await bad_guy.animation_finished
		is_not_moving = true
