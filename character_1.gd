extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking = false
const SPEED = 300.0
var move = true
@onready var hitbox: CollisionShape2D = $CollisionShape2D
var respawn_counter = 0
@onready var attack_hitbox: CollisionShape2D = $"AnimatedSprite2D/Area2D/Attack hitbox"
@onready var attack_area: Area2D = $AnimatedSprite2D/Area2D
var dead = false
var attack_cooldown = false
@onready var heart1: TextureRect = $CanvasLayer/Control/heart1
@onready var heart2: TextureRect = $CanvasLayer/Control/heart2
@onready var heart3: TextureRect = $CanvasLayer/Control/heart3
@onready var heart4: TextureRect = $CanvasLayer/Control/heart4
@onready var heart5: TextureRect = $CanvasLayer/Control/heart5





@onready var node_2d: Node2D = $"../Node2D"

@onready var full_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_full.png")
@onready var half_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_half.png")
@onready var empty_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_empty.png")
var is_hit = false
var health = 100
var amount = 0

func _ready() -> void: 
	hitbox.disabled = false
	attack_hitbox.disabled = true  # disables attack hitbox
	attack_area.monitoring = false 
	update_hearts()


func attack(): # attack function
	if attack_cooldown:
		return

	if not is_attacking: # checks if it player is attacking

		is_attacking = true
		sprite.play("attack") # plays attack animation
		
		attack_area.monitoring = true
		attack_hitbox.disabled = false
 # attack hitbox on


		await get_tree().create_timer(0.5).timeout # attack window

		attack_area.monitoring = false
		attack_hitbox.disabled = true
#attack hitbox off

		await sprite.animation_finished
		
		is_attacking = false #stops attacking
		
		


		attack_cooldown = true #stops attacking
		await get_tree().create_timer(1.0).timeout # attack cooldown
		attack_cooldown = false



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		var pause_menue = get_tree().current_scene.get_node("CanvasLayer")
		if pause_menue:
			pause_menue.pausing()

	if respawn_counter >= 3:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")



	var direction = Vector2.ZERO

	if move and not dead: #checks if player is able to move and is not dead
		if Input.is_action_pressed("move forward"):
			direction.y -= 1 
# moves forward
		if Input.is_action_pressed("move back"):
			direction.y += 1
# moves backwards
		if Input.is_action_pressed("Move left"):
			direction.x -= 1
			sprite.flip_h = true
# moves left
		if Input.is_action_pressed("mve right"):
			direction.x += 1
			sprite.flip_h = false
# moves right

	velocity = direction.normalized() * SPEED
# player velocity

	move_and_slide()
	

	
	if is_attacking:
		pass
	elif direction != Vector2.ZERO and not is_hit and not dead:
		sprite.play("run") # plays running animarion if moving
	elif health <= 20 and not dead and not is_hit:
		sprite.play("breathing") # plays breathing animation if health is low
	elif not is_hit and not dead:
		sprite.play("idle") # plays idle animation if not moving

	if Input.is_action_pressed("Attack") and not is_attacking and not dead: # checks if attack button pressed
		if sprite.flip_h: # switches hit box position along with thw character when changing direction
			attack_hitbox.position.x = -41
		else:
			attack_hitbox.position.x = 41
		attack() # attack
	


	if health <= 0 and not dead: # checks if player is dead
		die()
		
	
func take_damage(_amount):
	is_hit = true
	health -= _amount
	update_hearts()
	if not is_attacking:
		sprite.play("hit")
	await sprite.animation_finished
	is_hit = false


func update_hearts():
	if health >= 100:
		heart5.texture = full_heart
	elif health >= 90 and  health < 100: # chages to half a heart
		heart5.texture = half_heart
	elif health >= 80 and  health < 100: # changes to empty heart
		heart5.texture = empty_heart

	if health >= 80:
		heart4.texture = full_heart
	elif health >= 70 and  health < 100:# chages to half a heart
			heart4.texture = half_heart
	elif health >= 60 and  health < 100: # changes to empty heart
			heart4.texture = empty_heart
	
	if  health >= 60:
		heart3.texture = full_heart
	elif health >= 50 and  health < 100: # chages to half a heart
			heart3.texture = half_heart
	elif health >=40 and  health < 100: # changes to empty heart
				heart3.texture = empty_heart

	if health >= 40:
		heart2.texture = full_heart
	elif health >= 30 and  health < 100: # chages to half a heart
		heart2.texture = half_heart
	elif health >= 20 and  health < 100: # changes to empty heart
		heart2.texture = empty_heart
	
	if health >= 20:
		heart1.texture = full_heart
	elif health >= 10 and  health < 100: # chages to half a heart
		heart1.texture = half_heart
	elif health >= 0 and  health < 100: # changes to empty heart
		heart1.texture = empty_heart

func die():
	dead = true
	move = false # disables moving
	is_attacking = true
	sprite.play("death") # plays death animation
	hitbox.disabled = true
	await sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	respawn()


func respawn():
	dead = false
	move = true 
	is_attacking = false
	hitbox.disabled = false
	health = 100
	respawn_counter += 1
	update_hearts()
	var spawn = get_tree().current_scene.get_node("Spawnpoint")
	global_position = spawn.global_position
