extends Control

var stream: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = AudioStreamPlayer2D.new()
	stream.stream = preload("res://Sound/Idle Funk.mp3")
	
	stream.volume_db = 6
	stream.finished.connect(play_music)
	
	self.add_child(stream)
	play_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func play_music():
	stream.play()


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameScene_Markus.tscn")
	
func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_button_mouse_entered():
	get_node("quit_button").modulate = Color(1, 1, 1, 0.3)
	
func _on_quit_button_mouse_exited():
	get_node("quit_button").modulate = Color(1, 1, 1, 0)

func _on_credits_button_mouse_entered():
	get_node("credits_button").modulate = Color(1, 1, 1, 0.3)

func _on_credits_button_mouse_exited():
	get_node("credits_button").modulate = Color(1, 1, 1, 0)

func _on_start_game_button_mouse_entered():
	get_node("start_game_button").modulate = Color(1, 1, 1, 0.3)

func _on_start_game_button_mouse_exited():
	get_node("start_game_button").modulate = Color(1, 1, 1, 0)

