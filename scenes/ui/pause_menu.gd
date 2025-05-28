extends Control

signal pause_quit_to_title

@onready var resume_button = $Base/Logo/MenuButtons/Resume


func _on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()


func _on_resume_pressed() -> void:
	hide()
	get_tree().set_pause(false)


func _on_quit_pressed() -> void:
	pause_quit_to_title.emit()
	hide()
	get_tree().set_pause(false)
