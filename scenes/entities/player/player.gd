class_name Player

extends CharacterBody2D

signal dead
signal quit_to_title
signal restart_level

const DEFAULT_WALK_SPEED = 120

@export var walk_speed = DEFAULT_WALK_SPEED
@export var health = 8
@export var flasks = 4

var is_paused = false

@onready var animplayer = $Animate
@onready var animplayer_extra = $AnimationPlayer
@onready var camera = $Camera
@onready var interact_ray = $InteractRay
@onready var hud = $CanvasLayer/Hud
@onready var dead_popup = $CanvasLayer/PlayerDeadPopup
@onready var won_popup = $CanvasLayer/PlayerWonPopup
@onready var sfx_hurt = $SFXHurt


func _determine_direction():
	var input_vector = Vector2.ZERO
	input_vector.x = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	)
	input_vector.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	input_vector = input_vector.normalized()

	var is_moving: bool = false
	if input_vector.x != 0:
		is_moving = true
		velocity.x = lerp(velocity.x, walk_speed * input_vector.x, 1)
		animplayer.flip_h = input_vector.x < 0
		interact_ray.target_position = Vector2(-32, 0) if input_vector.x < 0 else Vector2(32, 0)
	else:
		velocity.x = lerp(velocity.x, 0.0, 1)

	if input_vector.y != 0:
		is_moving = true
		velocity.y = lerp(velocity.y, walk_speed * input_vector.y, 1)
		interact_ray.target_position = Vector2(0, 32) if input_vector.y < 0 else Vector2(0, -32)

	else:
		velocity.y = lerp(velocity.y, 0.0, 1)
	_change_animation(is_moving)


func _change_animation(is_moving: bool) -> void:
	if health <= 0 && is_paused:
		animplayer.play("dead")
	elif is_moving:
		animplayer.play("walk")
	else:
		animplayer.play("idle")


func _physics_process(_delta: float) -> void:
	if health <= 0 || is_paused:
		return
	_determine_direction()
	move_and_slide()


func take_damage(damage: int):
	health -= damage
	animplayer_extra.play("hurt")
	if health <= 0:
		health = 0
		is_paused = true
		dead.emit()

	sfx_hurt.play()
	hud.player_health_change(health)


func _heal():
	if flasks > 0 && health < 8:
		flasks -= 1
		health += 2
		if health > 8:
			health = 8  # cap health
		hud.player_health_change(health)
		hud.player_flask_change(flasks)


func _interact():
	var collider = interact_ray.get_collider()

	if interact_ray.is_colliding() and collider is Interactable:
		collider.interact()


func _unhandled_input(event: InputEvent) -> void:
	if health <= 0 || is_paused:
		return
	if event.is_action_pressed("heal"):
		_heal()
	elif event.is_action_pressed("interact"):
		_interact()


func change_camera_limits(limit_top: int, limit_bottom: int, limit_right: int, limit_left: int):
	camera.limit_top = limit_top
	camera.limit_bottom = limit_bottom
	camera.limit_right = limit_right
	camera.limit_left = limit_left


func game_won() -> void:
	won_popup.visible = true
	is_paused = true
	_change_animation(false)


func _on_dead() -> void:
	dead_popup.visible = true
	is_paused = true
	_change_animation(false)


func _on_player_dead_popup_pressed_restart_level() -> void:
	restart_level.emit()


func _on_player_won_popup_pressed_restart_level() -> void:
	restart_level.emit()


func _on_player_dead_popup_pressed_quit_to_title() -> void:
	quit_to_title.emit()


func _on_player_won_popup_pressed_quit_to_title() -> void:
	quit_to_title.emit()
