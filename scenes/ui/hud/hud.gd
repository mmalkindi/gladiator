class_name PlayerHud

extends Control

@export var player_max_health: int = 8
@export var boss_max_health: int = 20
@onready var player_heart_contaner = $Base/ContainerBase/HeartContainersBase/PlayerHeartContainer
@onready var boss_heart_container = $Base/ContainerBase/HeartContainersBase/BossHeartContainer
@onready var heal_count: Label = $Base/ContainerBase/ItemContainer/HealCount


func _rerender_hearts(new_health: int, is_boss: bool):
	var container: BoxContainer = player_heart_contaner if !is_boss else boss_heart_container
	var max_health: int = player_max_health if !is_boss else boss_max_health
	var full_heart_texture = (
		load("res://assets/ui/heart.png") if !is_boss else load("res://assets/ui/boss_heart.png")
	)
	var half_heart_texture = (
		load("res://assets/ui/half_heart.png")
		if !is_boss
		else load("res://assets/ui/half_boss_heart.png")
	)
	var damaged_heart_texture = (
		load("res://assets/ui/damaged_heart.png")
		if !is_boss
		else load("res://assets/ui/dead_boss_heart.png")
	)
	# special case if player is DEAD
	if new_health <= 0 && !is_boss:
		damaged_heart_texture = load("res://assets/ui/dead_heart.png")

	@warning_ignore("integer_division")
	var healed_hearts: int = new_health / 2
	@warning_ignore("integer_division")
	var max_hearts: int = max_health / 2
	var has_half_heart: int = new_health % 2 == 1
	if new_health > 0:
		# set these as healed hearts
		for i in range(1, healed_hearts + 1):
			container.get_child(i).texture = full_heart_texture
		if has_half_heart:
			container.get_child(healed_hearts + 1).texture = half_heart_texture
	# set the rest as fully unhealed hearts
	if has_half_heart:
		healed_hearts += 1  # skip last half heart if exists
	for i in range(healed_hearts + 1, max_hearts + 1):
		container.get_child(i).texture = damaged_heart_texture


func player_health_change(new_health: int):
	_rerender_hearts(new_health, false)


func player_flask_change(new_flasks: int):
	heal_count.text = str(new_flasks)


func boss_health_change(new_health: int):
	_rerender_hearts(new_health, true)


func boss_show_health():
	for child in boss_heart_container.get_children():
		child.visible = true
