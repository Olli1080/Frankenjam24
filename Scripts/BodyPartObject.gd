extends RigidBody2D

signal clicked(this : RigidBody2D)
signal released(this : RigidBody2D)

var sprite : Sprite2D

var dock_points : Array[Area2D]
var dock_points_contact : Array[PairArea2D]
var offset_held = Vector2(0, 0);

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
		if dock_points_contact.size() == 1:
			append_to_dock(dock_points_contact[0].first, dock_points_contact[0].second)
		for p in dock_points:
			p.monitoring = value
		dock_points_contact.clear()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $LeftArmTest
	for child in get_children():
		if child.is_in_group("DockPoint"):
			dock_points.append(child)
			child.area_entered.connect(_on_dock_node_area_entered.bind(child))
			child.area_exited.connect(_on_dock_node_area_exited.bind(child))

func append_to_dock(own_child : Area2D, dock_point : Area2D):
	print("APPEND!!")
	reparent(get_parent())
	dock_point.monitorable = false
	freeze = false
	input_pickable = false
	var node = PinJoint2D.new()
	node.set_name("PinJoint2D")
	node.position = own_child.position
	node.node_a = self.get_path()
	node.node_b = dock_point.get_parent().get_path()
	add_child(node)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position() + offset_held

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			print("Press")
			offset_held = self.global_position - event.position
			held = true
		elif event.is_released():
			held = false
		viewport.set_input_as_handled();

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
	if (!other_area.is_in_group("DockPoint") || dock_points_contact.has(other_area)):
		return
	dock_points_contact.append(PairArea2D.new(own_child, other_area))
	print("Area {} has entered Dock Point {}".format([own_child.name, other_area.name], "{}"))
	pass # Replace with function body.

func _on_dock_node_area_exited(other_area : Area2D, own_child : Area2D):
	if (!other_area.is_in_group("DockPoint") || !dock_points_contact.has(other_area)):
		return
	dock_points_contact.erase(PairArea2D.new(own_child, other_area))
	print("Area {} has left Dock Point {}".format([own_child.name, other_area.name], "{}"))
	pass # Replace with function body.
