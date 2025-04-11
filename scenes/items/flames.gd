extends LinkedItem

@onready var collission: CollisionShape2D = $CollisionShape2D
@onready var sfx: AudioStreamPlayer2D = $sfx


func _show_flames() -> void:
	for children in get_children():
		if children is Sprite2D and children.name != "base":
			children.visible = true
	sfx.play()


func _hide_flames() -> void:
	for children in get_children():
		if children is Sprite2D and children.name != "base":
			children.visible = false
	sfx.stop()


func _ready() -> void:
	trigger(false)


func trigger(set_flame: bool) -> void:
	collission.set_deferred("disabled", !set_flame)
	if set_flame:
		_show_flames()
	else:
		_hide_flames()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
	if body is Boss:
		body.take_damage(2)
