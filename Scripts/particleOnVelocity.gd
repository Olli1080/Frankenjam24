extends GPUParticles2D

var parent : RigidBody2D

func _ready():
	parent = get_parent()

func _process(delta):
	if parent:
		emitting = parent.linear_velocity.length() >= parent.particle_vel_threshold
