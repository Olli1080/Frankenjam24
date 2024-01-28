extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var morgue : TheMorgue = $"/root/TheMorgue"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cloud_collider_clicked():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
