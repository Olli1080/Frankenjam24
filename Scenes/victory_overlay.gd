extends Control

@onready var trait_label: Label = get_node("VBoxContainer/Label2")
# Called when the node enters the scene tree for the first time.
func _ready():
	var the_morgue : TheMorgue = $"/root/TheMorgue"
	var player_body : Node2D = the_morgue.player_body.instantiate()
	$attachPoint.add_child(player_body)
	
	player_body.global_position = $bodyPosition.global_position

	var i: int = 1
	
	for c in player_body.get_children():
		if "notesCharacteristicsText" in c:
			trait_label.text += "* #%02d " % [i] + c.notesCharacteristicsText + "\n"
			i = i + 1
			# Body
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cloud_collider_clicked():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
