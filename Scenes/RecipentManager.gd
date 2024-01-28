extends StaticBody2D

@export var next_scene : PackedScene

func store_body_to_morgue():
	var node : Node2D = self
	var morgue : TheMorgue = $"/root/TheMorgue"
	
	morgue.player_body = PackedScene.new()
	var arr = []
	arr.append_array(get_children())
	for c in get_children():
		c.owner = self
		arr.append_array(c.get_children())
	morgue.player_body.pack(node)
	print("Packed!")
	
	get_tree().change_scene_to_packed(next_scene)
