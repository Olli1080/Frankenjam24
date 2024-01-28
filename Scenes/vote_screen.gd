extends Control

@onready var timer: Timer = get_node("Timer")
@onready var time_label: Label = get_node("Label")
@export var next_scene : PackedScene
@export var tooltip : ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	var the_morgue : TheMorgue = $"/root/TheMorgue"
	var player_body : Node2D = the_morgue.player_body.instantiate()
	player_body.position = $PlayerSpot.position
	player_body.update_tooltip(tooltip)
	player_body.set_grabable(false)
	add_child(player_body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var left = timer.time_left as int
	var minutes = left / 60
	var seconds = left - minutes * 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func store_body_to_morgue():
	var node : Node2D = $PlayerSpot.get_child(0)
	var morgue : TheMorgue = $"/root/TheMorgue"
	
	#morgue.player_body = PackedScene.new()
	#var arr = []
	#arr.append_array(get_children())
	#for c in get_children():
		#c.owner = node
		#arr.append_array(c.get_children())
	#morgue.player_body.pack(node)
	
	get_tree().change_scene_to_packed(next_scene)

func _on_cloud_collider_left_clicked():
	pass # Replace with function body.


func _on_cloud_collider_middle_clicked():
	store_body_to_morgue()
	pass # Replace with function body.


func _on_cloud_collider_right_clicked():
	pass # Replace with function body.


func _on_timer_timeout():
	store_body_to_morgue()
