extends Control

signal pressed_restart_level
signal pressed_quit_to_title

@onready var restart_button: Button = $Base/Logo/MenuButtons/Restart


func _on_visibility_changed() -> void:
	if visible:
		restart_button.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_restart_pressed() -> void:
	pressed_restart_level.emit()


func _on_quit_pressed() -> void:
	pressed_quit_to_title.emit()
