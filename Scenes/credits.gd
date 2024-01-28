extends Control

@onready var text: Label = get_node("Label")
@onready var begrenzung: Node2D = get_node("CreditsUpperPart/begrenzung")

#signal credits_done
var done: bool = false
var timestamp_done = null

var stream: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = AudioStreamPlayer2D.new()
	stream.stream = preload("res://Sound/Idle Funk.mp3")
	
	stream.volume_db = 6
	stream.finished.connect(play_music)
	
	self.add_child(stream)
	play_music()
	
func play_music():
	stream.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if done:
		var fadeout_time = Time.get_ticks_msec() - timestamp_done
		if fadeout_time > 3000:
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		else:
			stream.volume_db = lerp(6, 0, fadeout_time / 3000.0)
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
