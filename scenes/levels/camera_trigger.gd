extends Area2D

@export var limit_left = 0
@export var limit_top = 0
@export var limit_right = 0
@export var limit_bottom = 0


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.change_camera_limits(limit_top, limit_bottom, limit_right, limit_left)
