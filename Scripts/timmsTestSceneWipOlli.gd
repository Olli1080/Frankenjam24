extends Node2D

@onready var Handsaw: Node2D = get_node("Handsaw")
@onready var SawMid: Node2D = get_node("Handsaw/MidPoint")
@onready var SawLower: Node2D = get_node("Handsaw/LowerEndNode")
@onready var SawUpper: Node2D = get_node("Handsaw/UpperEndNode")

@export var tool_idle_position: Vector2
@export var tool_idle_rotation: float

var click_active: bool = false
var sawing: bool = false
var to_saw_transition: bool = true

var positionIndex: int = 0
var relativeProgress: float = 0.0

var CurrentNode = null

var lerp_target_position
var lerp_target_angle
var lerp_t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Handsaw.global_position = tool_idle_position
	tool_idle_rotation = tool_idle_rotation * PI / 180.0
	Handsaw.rotation = tool_idle_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lerp_target_position == Handsaw.global_position:
		lerp_target_position = null
		if to_saw_transition:
			sawing = true
		else:
			click_active = false
		to_saw_transition = false
	
	if lerp_target_position != null:
		lerp_t += 0.4 * delta
		Handsaw.global_position = Handsaw.global_position.lerp(lerp_target_position, lerp_t)
		Handsaw.rotation = lerp(Handsaw.rotation, lerp_target_angle, lerp_t)

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
	#set_saw_position_with_offset(get_global_point_pos(StartPosLineSegment + relativeProgress * CutAxis) + offset)
	set_saw_position_with_offset(CurrentNode.get_node("Line2D").global_position + StartPosLineSegment + relativeProgress * CutAxis + offset)

func move_idle_tool(target_position: Vector2, target_angle: float):
	lerp_t = 0
	lerp_target_position = target_position
	lerp_target_angle = target_angle

func _input(event):
	if sawing and event is InputEventMouseMotion:
		var SawAxis: Vector2 = (SawUpper.global_position - SawLower.global_position).normalized()
		var projection: float = event.relative.dot(SawAxis)
		
		relativeProgress = min(relativeProgress + abs(projection) / 500.0, 1.0)
		set_along_line(projection * SawAxis)
		if (relativeProgress == 1.0):
			if (positionIndex < CurrentNode.get_node("Line2D").get_point_count() - 2):
				positionIndex = positionIndex + 1
				relativeProgress = 0.0
			else:
				sawing = false
				move_idle_tool(tool_idle_position, tool_idle_rotation)

func handle_shared_click(parent, rotation: float):
	if click_active:
		return
	click_active = true
	
	CurrentNode = parent
	
	var startPos = CurrentNode.get_node("Line2D").get_point_position(0) + CurrentNode.get_node("Line2D").global_position#parent.global_position
	var local_offset = get_saw_local_offset().rotated(rotation - tool_idle_rotation)
	
	move_idle_tool(startPos + local_offset, rotation)
	#Handsaw.global_position = startPos + local_offset
	to_saw_transition = true
	positionIndex = 0
	parent.get_node("Node2D").queue_free()

func _on_right_arm_clicked(parent):
	handle_shared_click(parent, tool_idle_rotation)

func _on_head_clicked(parent):
	
	handle_shared_click(parent, -81.4 * PI / 180.0)
	
func _on_left_arm_clicked(parent):
	handle_shared_click(parent, -19.7 * PI / 180.0)

func _on_left_hand_clicked(parent):
	handle_shared_click(parent, 42 * PI / 180.0)

func _on_right_hand_clicked(parent):
	handle_shared_click(parent, 62.2 * PI / 180.0)


func _on_left_leg_clicked(parent):
	handle_shared_click(parent, 62.2 * PI / 180.0)


func _on_right_leg_clicked(parent):
	handle_shared_click(parent, 62.2 * PI / 180.0)


func _on_right_foot_clicked(parent):
	handle_shared_click(parent, 62.2 * PI / 180.0)


func _on_left_foot_clicked(parent):
	handle_shared_click(parent, 62.2 * PI / 180.0)
