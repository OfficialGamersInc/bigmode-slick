extends GPUParticles3D

@export var timer : Timer
@onready var slash_trail: GPUParticles3D = $SlashTrail
@onready var slash_trail_2: GPUParticles3D = $SlashTrail2
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
	timer.wait_time = lifetime
	
	slash_trail.emitting = true
	slash_trail_2.emitting = true
	gpu_particles_3d.emitting = true

func _on_timer_timeout() -> void:
	queue_free()
