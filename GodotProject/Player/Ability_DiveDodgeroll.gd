extends Node
class_name Ability_DiveDodgeroll

@export var dive_force : float = 50
@export var dodgeroll_force : float = 50
@export var dodgeroll_duration : float = 1
@export var dodgeroll_direction_smoothing : float = 4

@onready var char_control : CharacterController = get_parent()

enum ABILITY_STATE { READY, DIVE, DODGEROLL }
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
		_dodgeroll_direction = _dodgeroll_direction.slerp(
			moveVect.normalized(),
			dodgeroll_direction_smoothing * _delta
		).normalized()
	
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
	if _current_state == ABILITY_STATE.DODGEROLL:
		var vertVel = char_control.velocity.project(char_control.up_direction)
		char_control.velocity = vertVel + _dodgeroll_direction * dodgeroll_force
		if get_state_time() < dodgeroll_duration: return
		char_control.jump_enabled = true
		set_state(ABILITY_STATE.READY)
