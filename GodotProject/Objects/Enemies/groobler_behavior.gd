extends CharacterBody3D

@export var movement_speed: float = 4.0
@export var target_spacing : float = 0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

@export var refresh_cooldown : float = 0.125
var _refresh_timer : float = 0

var look_vector : Vector3 = Vector3.FORWARD
@export var target : CharacterController

@export_category("Visual Rotation")
enum AutoRotationType {NONE, MOVEMENT, LOOK}
@export var autoRotationMode : AutoRotationType = AutoRotationType.MOVEMENT
@export var visualRotationLerpSpeed : float = 16

func _ready() -> void:
	target = get_tree().get_nodes_in_group("Player")[0]
	
	print(target)
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func project_on_plane(point : Vector3, plane : Vector3):
	return point - point.project(plane)

func _process(delta: float) -> void:
	if target != null and _refresh_timer < refresh_cooldown :
		_refresh_timer += delta
	else :
		_refresh_timer = 0
		set_movement_target(target.global_position)

func _physics_process(delta):
	if target.global_position.distance_to(global_position) <= target_spacing:
		_on_velocity_computed(Vector3.ZERO)
		navigation_agent.set_velocity(Vector3.ZERO)
		return
	
	if target != null :
		look_vector = target.global_position - global_position
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
		#_on_velocity_computed(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	
		# rotate to face walking direction
	if autoRotationMode == AutoRotationType.MOVEMENT:
		var visualRotationBlend = 1-pow(0.5, delta * visualRotationLerpSpeed)
		if project_on_plane(velocity, up_direction).length() > 0.1: # input.length() > 0:
			#facing_angle = Vector2(velocity.z, velocity.x).angle()
			#model.rotation.y = lerp_angle(model.rotation.y, facing_angle, visualRotationLerpSpeed)
			global_basis = global_basis.slerp(Basis.looking_at(project_on_plane(velocity, up_direction), up_direction), visualRotationBlend)
		else:
			global_basis = global_basis.slerp(Basis.looking_at(global_basis * Vector3.FORWARD, up_direction), visualRotationBlend)
	elif autoRotationMode == AutoRotationType.LOOK:
		global_basis = Basis.looking_at(project_on_plane(look_vector, up_direction), up_direction)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
