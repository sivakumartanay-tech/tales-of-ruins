extends Area2D
@onready var bad_guy: AnimatedSprite2D = $"../Tutorial Enemy"
@onready var player_1: CharacterBody2D = $"../../Player1"
@onready var hitbox: Area2D = $"."
@onready var attack_hitbox: CollisionShape2D = $"AnimatedSprite2D/Area2D/Attack hitbox"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var enemy_health = 50
var is_not_moving = true
var player_inside = false

func _ready() -> void:
	bad_guy.flip_h = true # since enemy is facing player, enmey flips


func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		player_inside = true # damages player if he enters enemy
		damge_tick()



func _on_body_exited(_body: Node2D) -> void:
	if _body == player_1: # stops damageing if player left
		player_inside = false




func _process(_delta: float) -> void:
	if enemy_health <= 0: # checks if enemy is dead
		hitbox.monitoring = false
		collision_shape_2d.disabled = true
		bad_guy.play("death") # plays death animation
		await bad_guy.animation_finished
		get_parent().visible = false # enemy "dies"
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"): # registers hits
		is_not_moving = false
		enemy_health -= 10 # damages enemy
		print(enemy_health) 
		bad_guy.play("hit") # plays hit animation
		await bad_guy.animation_finished
		is_not_moving = true

func damge_tick():
	while player_inside:
		player_1.take_damage(10)
		await get_tree().create_timer(1.0).timeout
		if player_1.health == 0:
			break
