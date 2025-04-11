class_name Level

extends Node2D

signal restart_level
signal quit_to_title

@onready var boss: Boss = $Boss
@onready var player: Player = $Player
@onready var player_hud: PlayerHud = $Player.hud
@onready var arena_door = $ArenaDoor
@onready var arena_trigger = $ArenaTrigger


func _on_arena_trigger_body_entered(body: Node2D) -> void:
	if body is Player:
		arena_door.trigger(false)
		arena_trigger.queue_free()


func _on_boss_boss_state_change(state) -> void:
	if state == boss.BossState.PHASE1:
		player_hud.boss_show_health()
	elif state == boss.BossState.DEAD:
		player.game_won()


func _on_boss_taken_damage(new_health: int) -> void:
	player_hud.boss_health_change(new_health)


func _on_player_quit_to_title() -> void:
	quit_to_title.emit()
	self.queue_free()


func _on_player_restart_level() -> void:
	restart_level.emit()
	self.queue_free()
