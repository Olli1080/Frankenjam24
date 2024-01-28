extends Control

@onready var timer: Timer = get_node("Timer")
@onready var time_label: Label = get_node("Label")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var left = timer.time_left as int
	var minutes = left / 60
	var seconds = left - minutes * 60
	time_label.text = "%02d:%02d" % [minutes, seconds]


func _on_cloud_collider_left_clicked():
	pass # Replace with function body.


func _on_cloud_collider_middle_clicked():
	pass # Replace with function body.


func _on_cloud_collider_right_clicked():
	pass # Replace with function body.
