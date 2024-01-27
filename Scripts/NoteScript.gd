extends Node

@export var bodySprite : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	bodySprite.notesLabel = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	bodySprite.highlighting = true



func _on_mouse_exited():
	bodySprite.highlighting = false



