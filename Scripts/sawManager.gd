extends Node2D

@onready var Handsaw: Node2D = get_node("Handsaw")
@onready var SawMid: Node2D = get_node("Handsaw/MidPoint")
@onready var SawLower: Node2D = get_node("Handsaw/LowerEndNode")
@onready var SawUpper: Node2D = get_node("Handsaw/UpperEndNode")

@export var tool_idle_position: Vector2
@export var tool_idle_rotation: float

@onready var SawSound = preload("res://Sound/handsaw.mp3")
var ScreamSounds: Array[AudioStream]
var ScreamSoundsHorse: Array[AudioStream]
var ScreamStream: AudioStreamPlayer2D

var click_active: bool = false
var sawing: bool = false
var to_saw_transition: bool = true

var positionIndex: int = 0
var relativeProgress: float = 0.0

var CurrentNode = null

var lerp_target_position
var lerp_target_angle
var lerp_t = 0

var lastMovement: int = -1
var current_cut_point : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ScreamSounds.append(preload("res://Sound/timon_scream.mp3"))
	ScreamSounds.append(preload("res://Sound/timon_scream2.mp3"))
	ScreamSounds.append(preload("res://Sound/Markus_scream1.mp3"))
	ScreamSounds.append(preload("res://Sound/Markus_scream2.mp3"))
	ScreamSounds.append(preload("res://Sound/Markus_scream3.mp3"))
	ScreamSoundsHorse.append(preload("res://Sound/horse1.mp3"))
	ScreamSoundsHorse.append(preload("res://Sound/horse2.mp3"))
	ScreamSoundsHorse.append(preload("res://Sound/horse3.mp3"))
	ScreamStream = AudioStreamPlayer2D.new()
	ScreamStream.finished.connect(screamDone)
	ScreamStream.volume_db = 20
	self.add_child(ScreamStream)
	
	Handsaw.global_position = tool_idle_position
	tool_idle_rotation = tool_idle_rotation * PI / 180.0
	Handsaw.rotation = tool_idle_rotation
	$AudioStreamPlayer2D.stream = SawSound

func screamDone():
	if sawing:
		playScream()

func playScream():
	var stream: AudioStream	
	if self.get_parent().get_index() != 2:
		var idx: int = randi() % ScreamSounds.size()
		stream = ScreamSounds[idx]
	else:
		var idx: int = randi() % ScreamSoundsHorse.size()
		stream = ScreamSoundsHorse[idx]
		
	ScreamStream.stream = stream
	ScreamStream.play()

func playSound():
	if !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.play()
		
func stopSound():
	if $AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if lerp_target_position and (lerp_target_position - Handsaw.global_position).length() < 0.001:
		lerp_target_position = null
		if to_saw_transition:
			sawing = true
			playScream()
		else:
			click_active = false
		to_saw_transition = false
	
	if lerp_target_position != null:
		lerp_t += 0.4 * delta
		Handsaw.global_position = Handsaw.global_position.lerp(lerp_target_position, lerp_t)
		Handsaw.rotation = lerp(Handsaw.rotation, lerp_target_angle, lerp_t)
		
	if sawing:
		if Time.get_ticks_msec() - lastMovement > 300:
			stopSound()
		else:
			playSound()
	elif Time.get_ticks_msec() - lastMovement > 90:
		stopSound()
			
		

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
		
		lastMovement = Time.get_ticks_msec()
		
		relativeProgress = min(relativeProgress + abs(projection) / 500.0, 1.0)
		set_along_line(projection * SawAxis)
		if (relativeProgress == 1.0):
			if (positionIndex < CurrentNode.get_node("Line2D").get_point_count() - 2):
				positionIndex = positionIndex + 1
				relativeProgress = 0.0
			else:
				sawing = false
				current_cut_point.finished.emit(current_cut_point)
				current_cut_point = null
				move_idle_tool(tool_idle_position, tool_idle_rotation)

func handle_shared_click(parent, rotation: float):
	if click_active:
		return
	click_active = true
	
	current_cut_point = parent.get_child(0)
	CurrentNode = parent
	
	var startPos = CurrentNode.get_node("Line2D").get_point_position(0) + CurrentNode.get_node("Line2D").global_position#parent.global_position
	var local_offset = get_saw_local_offset().rotated(rotation - tool_idle_rotation)
	
	move_idle_tool(startPos + local_offset, rotation)
	#Handsaw.global_position = startPos + local_offset
	to_saw_transition = true
	positionIndex = 0
	current_cut_point.visible = false
	current_cut_point.get_node("CharacterBody2D").input_pickable = false
	

func _on_right_arm_clicked(parent):
	handle_shared_click(parent, tool_idle_rotation)

func _on_head_clicked(parent):
	
	handle_shared_click(parent, -81.4 * PI / 180.0)
	
func _on_left_arm_clicked(parent):
	handle_shared_click(parent, -19.7 * PI / 180.0)

func _on_left_hand_clicked(parent):
	handle_shared_click(parent, 42.2 * PI / 180.0)

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
