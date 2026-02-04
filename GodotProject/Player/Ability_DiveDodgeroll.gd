extends Ability
class_name Ability_DiveDodgeroll

@export var dive_force : float = 30
@export var dodgeroll_force : float = 22.5
@export var dodgeroll_duration : float = 0.5
@export var dodgeroll_jump_timing : float = 0.1
@export var dodgeroll_recovery_duration : float = 0.5
@export var dodgeroll_direction_smoothing : float = 4.0

@export_group("AnimationTree Values", "ATV_")
@export var ATV_dodgeroll : String = "parameters/conditions/Dodgeroll"

#@onready var char_control : CharacterController = get_parent()

enum ABILITY_STATE { READY, DIVE, DODGEROLL, RECOVER }
var _current_state : ABILITY_STATE = ABILITY_STATE.READY
var _last_state_change : float
var _dodgeroll_direction : Vector3

func set_state(new_state : ABILITY_STATE):
	_last_state_change = ScaledTime.CurrentTime
	_current_state = new_state

## Get how long we've been in the current state in seconds.
func get_state_time() -> float:
	return ScaledTime.CurrentTime - _last_state_change

func _ready() -> void:
	assert(char_control, "Ability_DiveDodgeroll must be a direct child of a CharacterController.")

func _physics_process(_delta: float) -> void:
	var moveVect = Math.project_on_plane(char_control.move_vector, char_control.up_direction)
	if moveVect.length() > 0.1:
		if moveVect.normalized().dot(_dodgeroll_direction) <= -1:
			#_dodgeroll_direction = moveVect.normalized()
			# Can't slerp when vectors are exactly opposed so we have to fix that.
			_dodgeroll_direction = _dodgeroll_direction.rotated(
				char_control.up_direction, deg_to_rad(5)
			)
		_dodgeroll_direction = _dodgeroll_direction.slerp(
			moveVect.normalized(),
			dodgeroll_direction_smoothing * _delta
		).normalized()
	
	if char_control.anim_tree:
		char_control.anim_tree.set(ATV_dodgeroll,
			_current_state == ABILITY_STATE.DODGEROLL or _current_state == ABILITY_STATE.DIVE
		)
	
	if _current_state == ABILITY_STATE.READY:
		if char_control.is_on_floor(): return
		if not Input.is_action_just_pressed("dive"): return
		char_control.velocity += -char_control.up_direction * dive_force
		#_dodgeroll_direction = moveVect.normalized()
		set_state(ABILITY_STATE.DIVE)
		
	elif _current_state == ABILITY_STATE.DIVE:
		if not char_control.is_on_floor(): return
		if char_control.is_on_floor() and char_control.last_is_on_floor:
			set_state(ABILITY_STATE.READY)
			printerr("Not sure how but DiveDodgeroll is in state DIVE while on the floor.")
			return
		if not (char_control.is_on_floor() and not char_control.last_is_on_floor): return
		if char_control.move_vector.length() < 0.1:
			set_state(ABILITY_STATE.READY)
			return
		
		#_dodgeroll_direction = moveVect.normalized()
		char_control.jump_enabled = false
		set_state(ABILITY_STATE.DODGEROLL)
		
	elif _current_state == ABILITY_STATE.DODGEROLL:
		var vertVel = char_control.velocity.project(char_control.up_direction)
		char_control.velocity = vertVel + _dodgeroll_direction * dodgeroll_force
		if get_state_time() > dodgeroll_duration - dodgeroll_jump_timing:
			char_control.jump_enabled = true
		if get_state_time() < dodgeroll_duration: return
		if not char_control.is_on_floor():
			char_control.clear_registered_slowdown_source("DiveDodgeRecovery")
			set_state(ABILITY_STATE.READY)
			return
		
		set_state(ABILITY_STATE.RECOVER)
		char_control.register_slowdown_source("DiveDodgeRecovery", 5)
		
	elif _current_state == ABILITY_STATE.RECOVER:
		if not char_control.is_on_floor():
			char_control.clear_registered_slowdown_source("DiveDodgeRecovery")
			set_state(ABILITY_STATE.READY)
		if get_state_time() < dodgeroll_recovery_duration: return
		char_control.clear_registered_slowdown_source("DiveDodgeRecovery")
		set_state(ABILITY_STATE.READY)












# Man, I hate this.
