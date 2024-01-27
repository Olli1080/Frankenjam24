extends Control

@onready var text: Label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = delta * 20
	text.size.y += offset
	text.position.y -= offset
