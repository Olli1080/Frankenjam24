extends Button


@export var body1 : Node2D
@export var body2 : Node2D
@export var body3 : Node2D

var timesPressed : int


# Called when the node enters the scene tree for the first time.
func _ready():
	for b in [body2, body3]:
		b.visible = false
		b.position += Vector2.UP * 2000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if timesPressed == 0:
		body1.visible = false
		body2.visible = true
		body1.position += Vector2.UP * 2000
		body2.position -= Vector2.UP * 2000
		timesPressed += 1
	elif timesPressed == 1:
		body2.visible = false
		body3.visible = true
		body2.position += Vector2.UP * 2000
		body3.position -= Vector2.UP * 2000
		timesPressed += 1
	elif timesPressed == 2:
		body3.position += Vector2.UP * 2000
		body3.visible = false
		timesPressed += 1
	elif timesPressed >= 3:
		print("Look at your partner")
	pass # Replace with function body.
