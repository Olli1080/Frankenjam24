extends StaticBody2D

@export var next_scene : PackedScene
var uwu_right: AudioStreamPlayer2D

func _ready():
	uwu_right = AudioStreamPlayer2D.new()
	var uwuSoundRight = preload("res://Sound/betty_uwu.mp3")
	uwu_right.stream = uwuSoundRight
	uwu_right.volume_db = 20
	self.add_child(uwu_right)
	uwu_right.finished.connect(store_body_to_morgue)

func sound_transition():
	uwu_right.play()

func store_body_to_morgue():
	var node : Node2D = self
	var morgue : TheMorgue = $"/root/TheMorgue"
	
	var arr = []
	arr.append_array(get_children())
	morgue.player_body = PackedScene.new()
	while arr.size() > 0:
		var cur_el = arr.pop_front()
		cur_el.owner = self
		arr.append_array(cur_el.get_children())
	morgue.player_body.pack(node)
	
	get_tree().change_scene_to_packed(next_scene)

func set_grabable(val : bool):
	for c in get_children():
		if "grabable" in c:
			c.grabable = val

func update_tooltip(tooltip : ColorRect):
	for c in get_children():
		if "bigTextRect" in c:
			c.bigTextRect = tooltip
