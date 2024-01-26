extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	#var offset = self.position# - self.global_position
	#print(self.global_position)
	#var boxPos = self.#transform.origin #self.get_global_position();
	var white : Color = Color.RED
	draw_circle(Vector2(0,0), 10, white)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_character_body_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("lol it works")
		queue_free()
