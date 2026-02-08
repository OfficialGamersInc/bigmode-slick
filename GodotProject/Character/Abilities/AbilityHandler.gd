extends Node3D
class_name AbilityHandler

## set to -1 to set to stamina_move_max when the game starts.
@export var stamina_move_cur : float = -1
@export var stamina_move_max : int = 3
## set to -1 to set to stamina_attack_max when the game starts.
@export var stamina_attack_cur : float = -1
@export var stamina_attack_max : int = 3
## how much stamina_move_cur and stamina_attack_cur regen in units per second.
@export var stamina_regen : float = 0.1

var abilities : Array[Ability]
signal stamina_updated_move
signal stamina_updated_attack

# input
var look_dir : Vector3
signal attack_requested

@export var look_duration : float
var _look_timer : float
var looking : bool

func get_char_control() -> CharacterController:
	return get_parent()

func get_ability(name : StringName) -> Ability:
	for ability in abilities:
		if ability.name == name: return ability
	
	return null

func set_look_dir(new_look : Vector3):
	look_dir = new_look
	get_char_control().look_vector = look_dir
	print(look_dir)
	

func start_temp_look() :
	looking = true
	get_char_control().autoRotationMode = CharacterController.AutoRotationType.LOOK
	_look_timer = look_duration

func request_attack():
	# I think this should be done in Ability_Slash
	#if not try_use_stamina_attack(): return
	attack_requested.emit()

func try_use_stamina_move() -> bool:
	if stamina_move_cur < 1: return false
	stamina_move_cur -= 1
	stamina_updated_move.emit()
	return true

func try_use_stamina_attack() -> bool:
	if stamina_attack_cur < 1: return false
	stamina_attack_cur -= 1
	stamina_updated_attack.emit()
	return true

## If you don't want a consumable to get used if the player is already full on
## stamina, check if this method returns false before destroying it.
func try_give_stamina_move() -> bool:
	if stamina_move_cur > stamina_move_max - 1: return false
	stamina_move_cur += 1
	stamina_updated_move.emit()
	return true
	
func try_give_stamina_attack() -> bool:
	if stamina_attack_cur > stamina_attack_max - 1: return false
	stamina_attack_cur += 1
	stamina_updated_attack.emit()
	return true

func _ready() -> void:
	if stamina_move_cur < 0: stamina_move_cur = stamina_move_max
	if stamina_attack_cur < 0: stamina_attack_cur = stamina_attack_max
	
	# Can't cast Array[any] to Array[Ability] so `abilities=find_children()` doesn't work. :/
	abilities = []
	abilities.assign(find_children("*", "Ability", false, true))

func _process(delta: float) -> void:
	var last_stamina_attack = stamina_attack_cur
	if stamina_attack_cur < stamina_attack_max:
		stamina_attack_cur += stamina_regen * delta
		if floor(stamina_attack_cur) != floor(last_stamina_attack):
			stamina_updated_attack.emit()
	
	var last_stamina_move = stamina_move_cur
	if stamina_move_cur < stamina_move_max:
		stamina_move_cur += stamina_regen * delta
		if floor(stamina_move_cur) != floor(last_stamina_move):
			stamina_updated_move.emit()
	
	if looking == true :
		_look_timer -= delta
		if _look_timer <= 0 :
			looking = false
			get_char_control().autoRotationMode = CharacterController.AutoRotationType.MOVEMENT
		
	















# LET ME SCROLL DOWN!!!
#
#   _._     _,-'""`-._
#  (,-.`._,'(       |\`-/|
#      `-.-' \ )-`( , o o)
#            `-    \`_`"'-
