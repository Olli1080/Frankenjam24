extends Node2D

@onready var Handsaw: Node2D = get_node("Handsaw")
@onready var SawMid: Node2D = get_node("Handsaw/MidPoint")
@onready var SawLower: Node2D = get_node("Handsaw/LowerEndNode")
@onready var SawUpper: Node2D = get_node("Handsaw/UpperEndNode")

var progress: float = 0.0
var sawing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_saw_local_offset():
	return Handsaw.global_position - SawMid.global_position

func _on_right_arm_clicked(parent):
	print(parent.name)
	var startPos = parent.get_node("Line2D").get_point_position(0) + parent.global_position
	var local_offset = get_saw_local_offset()
	#print(startPos)
	#print(get_node("Handsaw/MidPoint").position)
	Handsaw.global_position = startPos + local_offset
	sawing = true

func _input(event):
	if sawing and event is InputEventMouseMotion:
		var SawAxis: Vector2 = (SawUpper.global_position - SawLower.global_position).normalized()
		var projection: float = event.relative.dot(SawAxis)
		
		Handsaw.global_position += projection * SawAxis
		print("Ye hah")
