extends Node2D
const SPEED = 100
var target: CharacterBody2D = null
var chase_range = 150
var velocity = Vector2.ZERO
var is_moving = false
var is_attacking = false
var enemy_health = 60
var is_hit = false
var player_inside = false
var enemy_dead = false
@onready var attack: CollisionShape2D = $atttack_hitbox/attack
@onready var hitbox: Area2D = $hitbox
@onready var boss: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox: Area2D = $atttack_hitbox
@onready var collision_shape_2d: CollisionShape2D = $hitbox/CollisionShape2D

func _ready() -> void:
	boss.flip_h = true # since enemy is facing player, enmey flips
	find_player() # finds player


func _process(_delta: float) -> void:
	
	if is_moving and not is_attacking and not is_hit:
		boss.play("run") # if enemy is moving = plays running animation
	elif not is_attacking and not is_moving:
		boss.play("idle") # if enemy not moving and not attacking = animation plays idle

	if enemy_health <= 0: # checks if enemy is dead
		enemy_dead = true
		is_attacking = true
		hitbox.monitoring = false
		collision_shape_2d.disabled = true
		boss.play("death") # plays death animation
		await boss.animation_finished
		$".".queue_free() # enemy "dies"







func _on_hitbox_area_entered(_area: Area2D) -> void:
	
	if _area.is_in_group("damages"): # registers hits
		enemy_hit(10) # damages enemy




func _physics_process(delta: float) -> void:
	
	if target == null: # makes target as player
		find_player()
		return

	var distance = global_position.distance_to(target.global_position) # finds distance from it to player

	if distance <= chase_range and distance > 50 and not enemy_dead and not is_attacking: # chases the player to a certain distance
		is_moving = true
		var direction = (target.global_position - global_position).normalized() # normalizes direction
		global_position += direction * SPEED * delta # movement
		boss.flip_h = direction.x < 0 # flips enemy
		if direction.x < 0:
			attack_hitbox.position.x = -36 # flips hitbox
	else:
		is_moving = false
	if distance <= 50 and not enemy_dead: # checks if enemy is certain distance
		enemy_attack(10) # starts enemy attack



func find_player(): # locates player
	var players = get_tree().get_nodes_in_group("Players")
	if players.size() > 0:
		target = players[0]


	
func enemy_hit(_amount): # hurts enemy
	is_moving = false
	is_hit = true

	enemy_health -= _amount # reduces health

	change_color_boss()  # shows enemy is being hit
	if not is_attacking:
		boss.play("hit") # plays hit animation
	await boss.animation_finished # waits for hit animation to finnish
		
	is_hit = false
	is_moving = true


func enemy_attack(_amount): # enemy attack
	is_attacking = true

	attack.disabled = false # enables attack


	boss.play("attack") # plays attack animation
	await get_tree().create_timer(0.8).timeout
	attack_hitbox.monitoring = true # turn on player detection

	await boss.animation_finished # waits for enemy to finnish animation
	
		
	attack.disabled = true # turns off player detection
	attack_hitbox.monitoring = false
	is_attacking = false
	


func _on_atttack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"): #checks if the body is a player
		body.take_damage(10) # deals 10 damage

func change_color_boss():
	boss.modulate = Color(1,0.3,0.3)
	await get_tree().create_timer(0.5).timeout # duration
	boss.modulate = Color(1,1,1)
