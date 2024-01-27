extends Node2D

signal clicked
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_character_body_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		viewport.set_input_as_handled()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit()
		viewport.set_input_as_handled()
