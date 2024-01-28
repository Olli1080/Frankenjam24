extends StaticBody2D

@export var next_scene : PackedScene

func store_body_to_morgue():
	var node : Node2D = self
	var morgue : TheMorgue = $"/root/TheMorgue"
	
	morgue.player_body = PackedScene.new()
	for c in get_children():
		c.owner = self
	morgue.player_body.pack(node)
	
	get_tree().change_scene_to_packed(next_scene)
	
func update_tooltip(tooltip : ColorRect):
	for c in get_children():
		if "bigTextRect" in c:
			c.bigTextRect = tooltip
