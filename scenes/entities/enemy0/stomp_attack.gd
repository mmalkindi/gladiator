extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collission: CollisionShape2D = $CollisionShape2D
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var telegraph_timer: Timer = $TelegraphTimer
@onready var linger_timer: Timer = $LingerTimer
@onready var stomp_sfx: AudioStreamPlayer2D = $StompSFX


func _ready() -> void:
	sprite.texture = load("res://assets/entities/enemy0/attack_circle.png")
	collission.set_deferred("disabled", true)
	animplayer.play("telegraph")
	telegraph_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if body is Player && !collission.disabled:
		body.take_damage(3)


func _on_telegraph_timer_timeout() -> void:
	animplayer.stop(false)
	sprite.texture = load("res://assets/entities/enemy0/stomp_fist.png")
	collission.set_deferred("disabled", false)
	stomp_sfx.play()
	linger_timer.start()


func _on_linger_timer_timeout() -> void:
	self.queue_free()
