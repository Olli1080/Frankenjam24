extends GPUParticles2D

var parent : RigidBody2D
var dock_node : Area2D = null
 
func distance_to(to : Node2D):
	return (to.global_position - global_position).length()

func _ready():
	parent = get_parent().get_parent()
	dock_node = get_parent()
	# for c in get_parent().get_children():
	#	if c.is_in_group("DockPoint"):
	#		if !dock_node || distance_to(c) < distance_to(dock_node):
	#			dock_node = c

func _process(delta):
	if parent && dock_node:
		emitting = (dock_node.monitorable || dock_node.monitoring) && parent.linear_velocity.length() >= parent.particle_vel_threshold
