extends Node3D
class_name AbilityHandler

## set to -1 to set to stamina_move_max when the game starts.
@export var stamina_move_cur : float = -1
@export var stamina_move_max : int = 3
## set to -1 to set to stamina_attack_max when the game starts.
@export var stamina_attack_cur : float = -1
@export var stamina_attack_max : int = 3
@export var stamina_regen : float = 0.1

var abilities : Array[Ability]

# input
var look_dir : Vector3
signal attack_requested

func get_char_control() -> CharacterController:
	return get_parent()

func get_ability(name : StringName) -> Ability:
	for ability in abilities:
		if ability.name == name: return ability
	
	return null

func set_look_dir(new_look : Vector3):
	look_dir = new_look

func request_attack():
	# I think this should be done in Ability_Slash
	#if not try_use_stamina_attack(): return
	attack_requested.emit()

func try_use_stamina_move() -> bool:
	if stamina_move_cur < 1: return false
	stamina_move_cur -= 1
	return true

func try_use_stamina_attack() -> bool:
	if stamina_attack_cur < 1: return false
	stamina_attack_cur -= 1
	return true

func _ready() -> void:
	if stamina_move_cur < 0: stamina_move_cur = stamina_move_max
	if stamina_attack_cur < 0: stamina_attack_cur = stamina_attack_max
	
	# Can't cast Array[any] to Array[Ability] so `abilities=find_children()` doesn't work. :/
	abilities = []
	abilities.assign(find_children("*", "Ability", false, true))

func _process(delta: float) -> void:
	stamina_attack_cur += stamina_regen * delta
	stamina_move_cur += stamina_regen * delta













# LET ME SCROLL DOWN!!!
