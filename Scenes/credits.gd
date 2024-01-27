extends Control

@onready var text: Label = get_node("Label")
@onready var begrenzung: Node2D = get_node("CreditsUpperPart/begrenzung")

#signal credits_done
var done: bool = false
var timestamp_done = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if done:
		if Time.get_ticks_msec() - timestamp_done > 3000:
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		return
		
	var offset = delta * 40
	if text.get_visible_line_count() != text.get_line_count():
		text.size.y += offset
		text.position.y -= offset
	else:
		text.position.y -= offset
		if (begrenzung.global_position.y - (text.position.y + text.size.y) > 0):
			done = true
			timestamp_done = Time.get_ticks_msec()
			#credits_done.emit()
