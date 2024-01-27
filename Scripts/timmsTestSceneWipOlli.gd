extends Node2D

@onready var Handsaw: Node2D = get_node("Handsaw")
@onready var SawMid: Node2D = get_node("Handsaw/MidPoint")
@onready var SawLower: Node2D = get_node("Handsaw/LowerEndNode")
@onready var SawUpper: Node2D = get_node("Handsaw/UpperEndNode")

@export var tool_idle_position: Vector2

var sawing: bool = false

var positionIndex: int = 0
var relativeProgress: float = 0.0

var CurrentNode = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Handsaw.global_position = tool_idle_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_saw_local_offset():
	return Handsaw.global_position - SawMid.global_position
	
func saw_position_with_offset(position: Vector2):
	return position + get_saw_local_offset()
	
func set_saw_position_with_offset(position: Vector2):
	Handsaw.global_position = position + get_saw_local_offset()
	
func get_global_point_pos(point: Vector2):
	return point + CurrentNode.global_position

func set_along_line(offset: Vector2):
	var StartPosLineSegment = CurrentNode.get_node("Line2D").get_point_position(positionIndex)
	var CutAxis: Vector2 = CurrentNode.get_node("Line2D").get_point_position(positionIndex + 1) - StartPosLineSegment
	set_saw_position_with_offset(get_global_point_pos(StartPosLineSegment + relativeProgress * CutAxis) + offset)
	pass

func _on_right_arm_clicked(parent):
	print(parent.name)
	CurrentNode = parent
	var startPos = CurrentNode.get_node("Line2D").get_point_position(0) + parent.global_position
	var local_offset = get_saw_local_offset()
	#print(startPos)
	#print(get_node("Handsaw/MidPoint").position)
	move_idle_tool(saw_position_with_offset(startPos))
	#Handsaw.global_position = startPos + local_offset
	sawing = true
	positionIndex = 0
	
func move_idle_tool(target: Vector2):
	Handsaw.global_position = target

func _input(event):
	if sawing and event is InputEventMouseMotion:
		var SawAxis: Vector2 = (SawUpper.global_position - SawLower.global_position).normalized()
		var projection: float = event.relative.dot(SawAxis)
		
		#Handsaw.global_position += 
		relativeProgress = min(relativeProgress + abs(projection) / 500.0, 1.0)
		set_along_line(projection * SawAxis)
		if (relativeProgress == 1.0):
			if (positionIndex < CurrentNode.get_node("Line2D").get_point_count() - 2):
				positionIndex = positionIndex + 1
				relativeProgress = 0.0
			else:
				sawing = false
				move_idle_tool(tool_idle_position)
