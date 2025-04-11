extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Input.get_connected_joypads() != []:
		text = "DPAD TO MOVE\nA TO INTERACT\nB TO HEAL"
