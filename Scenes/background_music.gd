extends Node2D

var stream: AudioStreamPlayer2D
var sounds: Array[AudioStream]
var offsets: Array[float] = [2.4, 2.4, 2.4]
# Called when the node enters the scene tree for the first time.
func _ready():
	stream = AudioStreamPlayer2D.new()
	sounds.append(preload("res://Sound/Amateur_Jazz_1.mp3"))
	sounds.append(preload("res://Sound/Amateur_Jazz_2.mp3"))
	sounds.append(preload("res://Sound/Amateur_Jazz_3.mp3"))
	
	stream.volume_db = 12
	stream.finished.connect(play_music)
	
	self.add_child(stream)
	play_music()

func play_music():
	var idx: int = randi() % sounds.size()
	
	stream.stream = sounds[idx]
	stream.play(offsets[idx])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
