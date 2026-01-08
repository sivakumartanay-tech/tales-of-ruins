extends Node2D

@onready var thrower: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 100
var target: CharacterBody2D = null
var chase_range = 150
var velocity = Vector2.ZERO
var is_moving = false
var is_attacking = false
var enemy_health = 20
var is_hit = false
var player_inside = false
var enemy_dead = false
@export var enemy_shot: PackedScene
@onready var hitbox: Area2D = $hitbox
@onready var collision_shape_2d: CollisionShape2D = $hitbox/CollisionShape2D
@onready var shootpoint: Marker2D = $Shootpoint
var can_shoot = true


func _ready() -> void:
	thrower.flip_h = true # since enemy is facing player, enmey flips
	find_player() # finds player


func _process(_delta: float) -> void:
	
	if is_moving and can_shoot and not is_hit and not is_attacking :
		thrower.play("run") # if enemy is moving = plays running animation
	elif not is_attacking and not is_moving and can_shoot:
		thrower.play("idle") # if enemy not moving and not attacking = animation plays idle

	if enemy_health <= 0: # checks if enemy is dead
		enemy_dead = true
		is_attacking = true
		hitbox.monitoring = false
		collision_shape_2d.disabled = true
		thrower.play("death") # plays death animation
		await thrower.animation_finished
		$".".queue_free() # enemy "dies"








func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("damages"): # registers hits
		enemy_hit(10) # damages enemy


func _physics_process(delta: float) -> void:
	
	if target == null: # makes target as player
		find_player()
		return

	var distance = global_position.distance_to(target.global_position) # finds distance from it to player

	if distance <= chase_range and distance > 500 and not enemy_dead and  can_shoot: # chases the player to a certain distance
		is_moving = true
		var direction = (target.global_position - global_position).normalized() # normalizes direction
		global_position += direction * SPEED * delta # movement
		thrower.flip_h = direction.x < 0 # flips enemy

	else:
		is_moving = false
	if distance <= 500 and not enemy_dead and can_shoot: # checks if enemy is certain distance
		shoot() # starts enemy attack



func find_player(): # locates player
	var players = get_tree().get_nodes_in_group("Players")
	if players.size() > 0:
		target = players[0]


	
func enemy_hit(_amount): # hurts enemy
	is_moving = false
	is_hit = true

	enemy_health -= _amount # reduces health

	print(enemy_health)  # temporary addition - shows enemy health
	thrower.play("hit") # plays hit animation
	await thrower.animation_finished # waits for hit animation to finnish
		
	is_hit = false
	is_moving = true


func shoot(): # enemy attack
	if not can_shoot:
		return

	if is_hit:
		return

	thrower.play("attack")

	is_attacking = true
	can_shoot = false
	var shot = enemy_shot.instantiate()
	shot.direction = (target.global_position - shootpoint.global_position).normalized()
	shot.global_position = shootpoint.global_position

	
	get_tree().current_scene.add_child(shot)
	
	is_attacking = false
	await get_tree().create_timer(2.0).timeout
	can_shoot = true
