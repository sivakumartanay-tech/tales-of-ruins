extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var shot_speed = 100
@export var damage = 10
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("projectile")
	position += direction * shot_speed * delta
	if direction.x <= 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	if direction.y <= 0:
		animated_sprite_2d.rotation_degrees = 90

		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		body.take_damage(damage)
		queue_free()
