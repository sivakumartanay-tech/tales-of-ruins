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
@onready var heart_1: TextureRect = $"../CanvasLayer/Control/TextureRect"
@onready var heart_2: TextureRect = $"../CanvasLayer/Control/TextureRect2"
@onready var heart_3: TextureRect = $"../CanvasLayer/Control/TextureRect3"
@onready var heart_4: TextureRect = $"../CanvasLayer/Control/TextureRect4"
@onready var heart_5: TextureRect = $"../CanvasLayer/Control/TextureRect5"
@onready var full_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_full.png")
@onready var half_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_half.png")
@onready var empty_heart = preload("res://sprites/0x72_DungeonTilesetII_v1.7/frames/ui_heart_empty.png")

var health = 100

func _ready() -> void:
	label.text = "healths " + str(health)
	attack_hitbox.disabled = true
	attack_area.monitoring = false


func attack():
	if not is_attacking:

		is_attacking = true
		sprite.play("attack")
		
		attack_area.monitoring = true
		attack_hitbox.disabled = false


		await get_tree().create_timer(0.5).timeout
		
		attack_area.monitoring = false
		attack_hitbox.disabled = true
		
		await sprite.animation_finished

		is_attacking = false


func _process(_delta: float) -> void:

	if health > 90 and health < 100:
		heart_5.texture = half_heart
	elif health < 90 and health > 80:
		heart_5.texture = empty_heart
	elif health < 80 and health > 70:
			heart_5.texture = empty_heart
			heart_4.texture = half_heart

	if is_attacking:
		return

	var direction = Vector2.ZERO
	if move and not dead:
		if Input.is_action_pressed("move forward"):
			direction.y -= 1 

		if Input.is_action_pressed("move back"):
			direction.y += 1

		if Input.is_action_pressed("Move left"):
			direction.x -= 1
			sprite.flip_h = true

		if Input.is_action_pressed("mve right"):
			direction.x += 1
			sprite.flip_h = false
	velocity = direction.normalized() * SPEED

	move_and_slide()
	
	if direction != Vector2.ZERO and not is_attacking:
		sprite.play("run")
	else:
		sprite.play("idle")

	if Input.is_action_pressed("Attack") and not is_attacking and not dead:
		if sprite.flip_h:
			attack_hitbox.position.x = -41
		attack()
		
	if health <= 0 and not dead:
		dead = true
		move = false
		is_attacking = true
		sprite.play("death")
		await sprite.animation_finished
		await get_tree().create_timer(0.5).timeout
		sprite.visible = false
		

		
		
