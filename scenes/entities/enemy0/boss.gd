class_name Boss

extends StaticBody2D

signal boss_state_change
signal taken_damage

enum BossState { SLEEP, PHASE1, PHASE2, DEAD }
enum BossAttackType { NONE, STOMP }

const PHASE1_ATTACKTIMER_MIN = 5
const PHASE1_ATTACKTIMER_MAX = 5
const PHASE2_ATTACKTIMER_MIN = 2
const PHASE2_ATTACKTIMER_MAX = 2

@export var attack_area_limit_top: Vector2i = Vector2i(-280, -308)
@export var attack_area_limit_bottom: Vector2i = Vector2i(280, 272)
@export var health: int = 20
@export var state: BossState = BossState.SLEEP

var current_attack: BossAttackType = BossAttackType.NONE

@onready var sprite: Sprite2D = $Sprite2D
@onready var animplayer_extra = $AnimationPlayer


func _awaken() -> void:
	_change_appearance(state)
	_repeat_phase_one_attack()


func _phase_two() -> void:
	_change_appearance(state)
	_repeat_phase_two_attack()


func _dead() -> void:
	_change_appearance(state)


func _stomp() -> void:
	var stomp_position: Vector2 = Vector2(
		randi_range(attack_area_limit_top.x, attack_area_limit_bottom.x),
		randi_range(attack_area_limit_top.y, attack_area_limit_bottom.y)
	)
	var stomp_instance: Node2D = (
		load("res://scenes/entities/enemy0/stomp_attack.tscn").instantiate()
	)
	stomp_instance.position = stomp_position
	call_deferred("add_child", stomp_instance)


func _attack_phase_one() -> void:
	# pick random attack
	var selected_attack = [BossAttackType.STOMP][randi_range(0, 0)]
	if selected_attack == BossAttackType.STOMP:
		_stomp()


func _repeat_phase_one_attack() -> void:
	if state != BossState.PHASE1:
		return
	_attack_phase_one()
	await (
		get_tree().create_timer(randf_range(PHASE1_ATTACKTIMER_MIN, PHASE1_ATTACKTIMER_MAX)).timeout
	)
	_repeat_phase_one_attack()


func _attack_phase_two() -> void:
	# pick random attack
	var selected_attack = [BossAttackType.STOMP][randi_range(0, 0)]
	if selected_attack == BossAttackType.STOMP:
		_stomp()


func _repeat_phase_two_attack() -> void:
	if state != BossState.PHASE2:
		return
	_attack_phase_two()
	await (
		get_tree().create_timer(randf_range(PHASE2_ATTACKTIMER_MIN, PHASE2_ATTACKTIMER_MAX)).timeout
	)
	_repeat_phase_two_attack()


func _change_appearance(new_state: BossState) -> void:
	if new_state == BossState.SLEEP:
		sprite.texture = load("res://assets/entities/enemy0/boss_sleep.png")
	elif new_state == BossState.PHASE1:
		sprite.texture = load("res://assets/entities/enemy0/boss_phase1.png")
	elif new_state == BossState.PHASE2:
		sprite.texture = load("res://assets/entities/enemy0/boss_phase2.png")
	elif new_state == BossState.DEAD:
		sprite.texture = load("res://assets/entities/enemy0/boss_dead.png")


func take_damage(damage: int):
	health -= damage
	animplayer_extra.play("hurt")
	# Awaken (start Phase 1) Boss if it's still sleeping
	if state == BossState.SLEEP:
		boss_state_change.emit(BossState.PHASE1)
	if health <= 8 && state == BossState.PHASE1:
		boss_state_change.emit(BossState.PHASE2)
	if health <= 0:
		boss_state_change.emit(BossState.DEAD)
	taken_damage.emit(health)


func _on_boss_state_change(new_state: BossState) -> void:
	state = new_state
	if state == BossState.PHASE1:
		_awaken()
	elif state == BossState.PHASE2:
		_phase_two()
	elif state == BossState.DEAD:
		_dead()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
