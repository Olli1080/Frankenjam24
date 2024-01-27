extends Button


@export var body1 : Node2D
@export var body2 : Node2D
@export var body3 : Node2D

var timesPressed : int


# Called when the node enters the scene tree for the first time.
func _ready():
	body2.visible = false
	body3.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if timesPressed == 0:
		body1.visible = false
		body2.visible = true
		timesPressed += 1
	elif timesPressed == 1:
		body2.visible = false
		body3.visible = true
		timesPressed += 1
	elif timesPressed == 2:
		body3.visible = false
		print("No more bodys")
		timesPressed += 1
	elif timesPressed >= 3:
		print("Look at your partner")
	pass # Replace with function body.
