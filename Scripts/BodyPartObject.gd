extends RigidBody2D

signal clicked(this : RigidBody2D)
signal released(this : RigidBody2D)

var sprite : Sprite2D

var offset_held = Vector2(0, 0);

var held = false : 
	get:
		return held
	set(value):
		if (value == held):
			return
		elif (value):
			clicked.emit(self)
		else:
			released.emit(self)
			apply_central_impulse(Input.get_last_mouse_velocity())
		held = value
		freeze = value

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $LeftArmTest
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position() + offset_held

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			print("Press")
			offset_held = self.global_position - event.position
			held = true
		elif event.is_released():
			print("Release")
			held = false
		viewport.set_input_as_handled();

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			print("Release")
			held = false

func _on_mouse_entered():
	sprite.modulate = Color.YELLOW
	pass # Replace with function body.


func _on_mouse_exited():
	sprite.modulate = Color.WHITE
	pass # Replace with function body.
