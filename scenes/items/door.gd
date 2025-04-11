extends LinkedItem

@export var is_open: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collission: CollisionShape2D = $CollisionShape2D


func _change_appearance(door_new_state: bool) -> void:
	sprite.visible = !door_new_state


func _ready() -> void:
	trigger(is_open)


func trigger(door_open_status: bool) -> void:
	is_open = door_open_status
	collission.set_deferred("disabled", is_open)
	_change_appearance(is_open)
