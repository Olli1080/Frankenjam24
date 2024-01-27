extends RigidBody2D

signal clicked(this : RigidBody2D)
signal released(this : RigidBody2D)

@export var sprite : Sprite2D
@export var rotation_sensitivity : float = 0.15
@export var particle_vel_threshold : float = 0.1

var dock_points : Array[Area2D]
var dock_points_contact : Array[PairArea2D]
var offset_held = Vector2(0, 0);

var upper_angle_limit : float = 30
var lower_angle_limit : float = -30

var held = false : 
	get:
		return held
	set(value):
		if (value == held):
			return
		elif (value):
			clicked.emit(self)
		else:
			released.emit(self)
			apply_central_impulse(Input.get_last_mouse_velocity())
		held = value
		freeze = value
		print(dock_points_contact.size())
		
		var glue_together : bool = dock_points_contact.size() >= 1
		
		if glue_together:
			append_to_dock(dock_points_contact[0].first, dock_points_contact[0].second)
			collision_layer = 4
		elif value:
			collision_layer = 2
		else:
			collision_layer = 1
		collision_mask = collision_layer
		for p in dock_points:
			p.monitoring = value
		dock_points_contact.clear()
		queue_redraw()
		

func _draw():
	if held:
		if dock_points_contact.size() >= 1:
			if dock_points_contact.size() >= 2:
				dock_points_contact.sort_custom(PairArea2D.distance_comparator)
			var dp = dock_points_contact[0]
			draw_line(dp.first.position, dp.first.position + (dp.second.global_position - dp.first.global_position).rotated(-rotation), Color.GREEN, 5.0, true)
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_child(0)
	for child in get_children():
		if child.is_in_group("DockPoint"):
			dock_points.append(child)
			child.area_entered.connect(_on_dock_node_area_entered.bind(child))
			child.area_exited.connect(_on_dock_node_area_exited.bind(child))
			child.monitorable = false
			child.monitoring = false

func append_to_dock(own_child : Area2D, dock_point : Area2D):
	print("APPEND!!")
	reparent(get_parent())
	dock_point.monitorable = false
	freeze = false
	input_pickable = false
	position += dock_point.global_position - own_child.global_position
	var node = PinJoint2D.new()
	node.set_name("PinJoint2D")
	node.position = own_child.position
	node.node_a = self.get_path()
	node.node_b = dock_point.get_parent().get_path()
	# node.set_angular_limit_enabled(true)
	# node.angular_limit_lower = dock_point.min_angle
	# node.angular_limit_upper = dock_point.max_angle
	node.disable_collision = false
	upper_angle_limit = dock_point.max_angle
	lower_angle_limit = dock_point.min_angle
	lock_rotation = false
	add_child(node)
	# Enable other dock points for docking
	for d in dock_points:
		if d != own_child:
			d.monitoring = false
			d.monitorable = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position() + offset_held
		queue_redraw()
		
func _integrate_forces(state):
	pass
	
func rotate_around_point(rotate : float):
	offset_held = offset_held.rotated(rotate)
	rotate(rotate)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			offset_held = self.global_position - get_global_mouse_position()
			held = true
		elif event.is_released():
			held = false
		viewport.set_input_as_handled();
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if held:
			rotate_around_point(rotation_sensitivity)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		if held:
			rotate_around_point(-rotation_sensitivity)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			held = false

func _on_mouse_entered():
	sprite.modulate = Color.YELLOW
	pass # Replace with function body.


func _on_mouse_exited():
	sprite.modulate = Color.WHITE
	pass # Replace with function body.


func _on_dock_node_area_entered(other_area : Area2D, own_child : Area2D):
	if (!other_area.is_in_group("DockPoint")):
		return
	dock_points_contact.append(PairArea2D.new(own_child, other_area))
	print("Area {} has entered Dock Point {}".format([own_child.name, other_area.name], "{}"))
	pass # Replace with function body.

func _on_dock_node_area_exited(other_area : Area2D, own_child : Area2D):
	if (!other_area.is_in_group("DockPoint")):
		return
	var i = 0
	var remove_idx = -1
	var tmp = PairArea2D.new(own_child, other_area)
	while i < dock_points_contact.size():
		if (dock_points_contact[i].is_same(tmp)):
			remove_idx = i
			break
		i += 1
	if remove_idx >= 0:
		dock_points_contact.remove_at(remove_idx)
	print("Area {} has left Dock Point {}".format([own_child.name, other_area.name], "{}"))
	pass # Replace with function body.
