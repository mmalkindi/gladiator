extends Interactable

enum LinkedItemType { DOOR, FLAMES, ARROWS, BOULDER }

const FLAMES_LOCK_TIME = 10
const ARROWS_LOCK_TIME = 10

@export var linked_item: NodePath
@export var item_type: LinkedItemType
@export var is_pulled: bool = false
@export var is_locked: bool = false

var lock_timeout: float

@onready var linked_item_node: LinkedItem = get_node(linked_item)
@onready var sprite: Sprite2D = $Sprite2D


func _change_appearance(new_pull_state: bool) -> void:
	var sprite_name = LinkedItemType.keys()[item_type]
	if new_pull_state:
		sprite.texture = load("res://assets/items/lever_" + sprite_name + "_down.png")
	else:
		sprite.texture = load("res://assets/items/lever_" + sprite_name + "_up.png")


func _ready() -> void:
	_change_appearance(is_pulled)


func _process(delta: float) -> void:
	if !is_locked:
		return
	lock_timeout -= delta
	if is_locked && lock_timeout <= 0:
		_release_lock()


func _release_lock() -> void:
	lock_timeout = 0
	is_locked = false
	is_pulled = false
	_change_appearance(is_pulled)
	linked_item_node.trigger(is_pulled)


func interact() -> void:
	if is_locked:
		return
	is_pulled = !is_pulled
	_change_appearance(is_pulled)
	if !linked_item_node:
		return

	linked_item_node.trigger(is_pulled)
	if item_type == LinkedItemType.FLAMES:
		lock_timeout = FLAMES_LOCK_TIME
		is_locked = true
	elif item_type == LinkedItemType.ARROWS:
		lock_timeout = ARROWS_LOCK_TIME
		is_locked = true
