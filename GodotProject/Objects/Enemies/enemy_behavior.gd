extends NavigationAgent3D
class_name EnemyBehavior

@export var movement_speed: float = 4.0
@export var target_spacing : float = 0
@export var attack_range : float = 4

var look_vector : Vector3 = Vector3.FORWARD
var target : CharacterController


@onready var char_control : CharacterController = get_parent()
var ability_handler : AbilityHandler
var ability_slash : Ability_Slash

enum BehaviorState {Idle, Aggro, Attacking}

@export_category("Visual Rotation")
enum AutoRotationType {NONE, MOVEMENT, LOOK}
@export var autoRotationMode : AutoRotationType = AutoRotationType.MOVEMENT
@export var visualRotationLerpSpeed : float = 16

func _ready() -> void:
	target = get_tree().get_nodes_in_group("Player")[0]
	
	velocity_computed.connect(_on_velocity_computed)
	
	ability_handler = NodeLib.FindChildOfCustomClass(char_control, AbilityHandler, true, false)
	ability_slash = NodeLib.FindChildOfCustomClass(ability_handler, Ability_Slash, true, false)

func set_movement_target(movement_target: Vector3):
	set_target_position(movement_target)

func _process(_delta: float) -> void:
	if target != null:
		set_movement_target(target.global_position)
		var dist = char_control.global_position.distance_to(target.global_position)
		
		
		if dist <= attack_range :
			ability_slash.try_attack()
	

func _physics_process(_delta):
	if target.global_position.distance_to(char_control.global_position) <= target_spacing:
		_on_velocity_computed(Vector3.ZERO)
		set_velocity(Vector3.ZERO)
		return
	
	if target != null :
		look_vector = target.global_position - char_control.global_position
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(get_navigation_map()) == 0:
		return
	if is_navigation_finished():
		return
	
	var next_path_position: Vector3 = get_next_path_position()
	var new_direction : Vector3 = char_control.global_position.direction_to(next_path_position)
	var new_velocity: Vector3 = new_direction * movement_speed
	if avoidance_enabled:
		set_velocity(new_velocity)
		#_on_velocity_computed(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
func _on_velocity_computed(safe_velocity: Vector3):
	if ((target.global_position - char_control.global_position) * Vector3(1,0,1)).length() <= target_spacing:
		char_control.move_vector = Vector3.ZERO;
		return
	
	#velocity = safe_velocity
	#char_control.jump_held = safe_velocity.y > 0
	char_control.move_vector = safe_velocity.normalized() #/ movement_speed
