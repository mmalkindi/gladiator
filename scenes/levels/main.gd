extends Node2D

const LEVEL00_PATH = "res://scenes/levels/level0/level00.tscn"
const MAINMENU_PATH = "res://scenes/ui/main_menu.tscn"

@onready var canvas_layer = $CanvasLayer


func _on_main_menu_start_game() -> void:
	var level0: PackedScene = load(LEVEL00_PATH)
	var instance: Level = level0.instantiate()
	instance.position = Vector2(0, 64)
	instance.restart_level.connect(_on_level00_restart_level)
	instance.quit_to_title.connect(_on_level00_quit_to_title)
	instance.name = "Level00"
	add_child(instance)

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_node("CanvasLayer/MainMenu").queue_free()


func _on_level00_restart_level() -> void:
	var level0: PackedScene = load(LEVEL00_PATH)
	var instance: Level = level0.instantiate()

	instance.position = Vector2(0, 64)
	instance.restart_level.connect(_on_level00_restart_level)
	instance.quit_to_title.connect(_on_level00_quit_to_title)
	instance.name = "Level00"
	add_child(instance)

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_level00_quit_to_title() -> void:
	var main_menu: PackedScene = load(MAINMENU_PATH)
	var instance: Node = main_menu.instantiate()

	instance.start_game.connect(_on_main_menu_start_game)
	instance.name = "MainMenu"
	canvas_layer.add_child(instance)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
