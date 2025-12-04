extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking = false
const SPEED = 300.0
var move = true
@onready var label: Label = $Label
@onready var attack_hitbox: CollisionShape2D = $"AnimatedSprite2D/Area2D/Attack hitbox"
@onready var attack_area: Area2D = $AnimatedSprite2D/Area2D
@onready var enemy_hitbox: Area2D = $Hitbox
var dead = false
@onready var node_2d: Node2D = $"../Node2D"
@onready var heart_3: TextureRect = $"../CanvasLayer/Control/TextureRect"
@onready var heart_1: TextureRect = $"../CanvasLayer/Control/TextureRect2"
@onready var heart_2: TextureRect = $"../CanvasLayer/Control/TextureRect3"
@onready var heart_4: TextureRect = $"../CanvasLayer/Control/TextureRect4"
@onready var heart_5: TextureRect = $"../CanvasLayer/Control/TextureRect5"
@onready var full_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_full.png")
@onready var half_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_half.png")
@onready var empty_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_empty.png")
var is_hit = false
var health = 100
var amount = 0

func _ready() -> void: 
	attack_hitbox.disabled = true  # disables attack hitbox
	attack_area.monitoring = false 



func attack(): # attack function
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


func _process(_delta: float) -> void:

	if health >= 90 and not health == 100: # chages to half a heart
		heart_5.texture = half_heart
	elif health >= 80 and not health == 100: # changes to empty heart
		heart_5.texture = empty_heart
	else:
		if health >= 70 and not health == 100:# chages to half a heart
			heart_4.texture = half_heart
		elif health >= 60 and not health == 100: # changes to empty heart
			heart_4.texture = empty_heart
		else:
			if health >= 50 and not health == 100: # chages to half a heart
				heart_3.texture = half_heart
			elif health >=40 and not health == 100: # changes to empty heart
				heart_3.texture = empty_heart
			else:
				if health >= 30 and not health == 100: # chages to half a heart
					heart_2.texture = half_heart
				elif health >= 20 and not health == 100: # changes to empty heart
					heart_2.texture = empty_heart
				else:
					if health >= 10 and not health == 100: # chages to half a heart
						heart_1.texture = half_heart
					elif health >= 0 and not health == 100: # changes to empty heart
						heart_1.texture = empty_heart



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
	elif direction != Vector2.ZERO and not is_hit:
		sprite.play("run") # plays running animarion if moving
	elif health <= 20:
		sprite.play("breathing") # plays breathing animation if health is low
	elif not is_hit:
		sprite.play("idle") # plays idle animation if not moving

	if Input.is_action_pressed("Attack") and not is_attacking and not dead: # checks if attack button pressed
		if sprite.flip_h: # switches hit box position along with thw character when changing direction
			attack_hitbox.position.x = -41
		attack() # attack
	
	if health <= 0 and not dead: # checks if player is dead
		dead = true
		move = false # disables moving
		is_attacking = true
		sprite.play("death") # plays death animation
		await sprite.animation_finished
		await get_tree().create_timer(0.5).timeout
		sprite.visible = false # player "dies"
		
	
func take_damage(_amount):
	is_hit = true
	health -= _amount
	sprite.play("hit")
	await sprite.animation_finished
	is_hit = false
