extends Node2D
@onready var player_1: CharacterBody2D = $"../Player1"
const SPEED = 100
var player = null
var chase_range = 150
var velocity = Vector2.ZERO
var is_moving = false
var is_attacking = false
var enemy_health = 50
var is_hit = false
var player_inside = false
var enemy_dead = false
var enemy_scene = preload("res://scenes/enemy.gd")
@onready var hitbox: Area2D = $Hitbox
@onready var tutorial_enemy: AnimatedSprite2D = $"Tutorial Enemy"
@onready var attack_hitbox: Area2D = $"Attack hitbox"
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

func _ready() -> void:
	player = player_1
	tutorial_enemy.flip_h = true # since enemy is facing player, enmey flips


func _process(_delta: float) -> void:
	if is_moving and not is_attacking and not is_hit:
		tutorial_enemy.play("run")
	elif not is_attacking:
		tutorial_enemy.play("idle")

	if enemy_health <= 0: # checks if enemy is dead
		enemy_dead = true
		is_attacking = true
		hitbox.monitoring = false
		collision_shape_2d.disabled = true
		tutorial_enemy.play("death") # plays death animation
		await tutorial_enemy.animation_finished
		$".".queue_free() # enemy "dies"


func _on_hitbox_body_exited(_body: Node2D) -> void:
	if _body == player_1: # stops damageing if player left
		player_inside = false # Replace with function body.


func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player_1.global_position)

	if distance < 50:
		if velocity.x < 0:
			attack_hitbox.position.x = -31.0
		velocity = Vector2.ZERO
		if player_1.health <= 0:
			return
		else:
			enemy_attack()
		return
	

	if distance <= chase_range and not enemy_dead:
		is_moving = true
		var direction = (player_1.global_position - global_position).normalized()
		velocity = direction * SPEED
		global_position += velocity * delta
		if direction.x < 0:
			tutorial_enemy.flip_h = true
		else:
			tutorial_enemy.flip_h = false
	elif velocity == Vector2.ZERO:
		is_moving = false




func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"): # registers hits
		is_moving = false
		is_hit = true
		enemy_health -= 10 # damages enemy
		
		print(enemy_health) 
		tutorial_enemy.play("hit") # plays hit animation
		await tutorial_enemy.animation_finished
		
		is_hit = false
		is_moving = true



#-------------Attack------------------------------
func enemy_attack():
	if is_attacking:
		return
	if player_1.health <= 0:
		is_moving = false
		return

	is_attacking = true
	is_moving = false
	attack_hitbox.monitoring = true
	print("ji")


	tutorial_enemy.play("attack")
	await tutorial_enemy.animation_finished
	player_1.take_damage(10)

		
	attack_hitbox.monitoring = false
	is_attacking = false
	is_moving = true

func damge_tick():
	while player_inside:
		player_1.take_damage(10)
		await get_tree().create_timer(1.0).timeout
		if player_1.health <= 0:
			break

func _on_hitbox_body_entered(_body: Node2D) -> void:
	print(_body)
	if _body.is_in_group("Player") and not enemy_dead:
		player_inside = true # damages player if he enters enemy
		damge_tick()

func _on_attack_hitbox_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		player_inside = true
		if player_inside:
			enemy_attack()



func _on_attack_hitbox_body_exited(_body: Node2D) -> void:
	player_inside = false
#----------------------------------------------------------------
