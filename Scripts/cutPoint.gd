extends Node2D

signal clicked
signal finished(cut_point : Node2D)

@export var radius : int = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	$CharacterBody2D/CollisionShape2D.shape.radius = radius
	pass # Replace with function body.

func _draw():
	#var offset = self.position# - self.global_position
	#print(self.global_position)
	#var boxPos = self.#transform.origin #self.get_global_position();
	var white : Color = Color.GREEN
	draw_circle(Vector2(0,0), radius, white)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_character_body_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		viewport.set_input_as_handled()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(get_parent())
		viewport.set_input_as_handled()
