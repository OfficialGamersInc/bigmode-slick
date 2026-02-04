extends Node3D
class_name AbilityHandler

var abilities : Array[Ability]

# input
var look_dir : Vector3
signal attack_requested

func _ready() -> void:
	# Can't cast Array[any] to Array[Ability] so `abilities=find_children()` doesn't work. :/
	abilities = []
	abilities.assign(find_children("*", "Ability", false, true))

func get_char_control() -> CharacterController:
	return get_parent()

func get_ability(name : StringName) -> Ability:
	for ability in abilities:
		if ability.name == name: return ability
	
	return null

func set_look_dir(new_look : Vector3):
	look_dir = new_look

func request_attack():
	attack_requested.emit()














# LET ME SCROLL DOWN!!!
