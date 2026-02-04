extends Node3D
class_name Ability

signal enabled_changed(_enabled : bool)

@export var enabled = true
@onready var ability_handler : AbilityHandler = get_parent()
@onready var char_control : CharacterController = ability_handler.get_char_control()

func set_enabled(_enabled : bool):
	enabled = _enabled
	enabled_changed.emit(_enabled)

#func get_character() -> CharacterController:
	#return ability_handler.get_char_control()
