extends Control

signal start_game

@onready var start_button: Button = $Base/Logo/MenuButtons/Start


func _on_start_pressed() -> void:
	start_game.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _ready() -> void:
	start_button.grab_focus()
