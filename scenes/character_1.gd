extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking = false
const SPEED = 300.0
var move = true
@onready var label: Label = $Label
@onready var attack_hitbox: CollisionShape2D = $"AnimatedSprite2D/Area2D/Attack hitbox"
@onready var attack_area: Area2D = $AnimatedSprite2D/Area2D
@onready var enemy_hitbox: Area2D = $Hitbox


var health = 100

func _ready() -> void:
	label.text = "health " + str(health)
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

	label.text = "health " + str(health)

	if is_attacking:
		return

	var direction = Vector2.ZERO
	if move:
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

	if Input.is_action_pressed("Attack") and not is_attacking:
		attack()
