extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collission: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	sprite.texture = load("res://assets/entities/enemy0/attack_circle.png")
	sprite.self_modulate.a = 0.5
	collission.set_deferred("disabled", true)
	await get_tree().create_timer(3).timeout
	sprite.self_modulate.a = 1
	collission.set_deferred("disabled", false)
	sprite.texture = load("res://assets/entities/enemy0/stomp_fist.png")
	await get_tree().create_timer(3).timeout
	self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player && !collission.disabled:
		body.take_damage(3)
