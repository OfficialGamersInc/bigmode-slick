extends Node
class_name PlayerInput

# TODO These are temporary. I don't really like the hard-coded sibling references.
@onready var ability_handler : AbilityHandler = $"../AbilityHandler"
@onready var camera : Camera3D = $"../Camera3DOverhead"
@onready var char_control : CharacterController = get_parent()

func _process(_delta: float) -> void:
	ability_handler.set_look_dir(get_mouse_look_vect())
	if Input.is_action_just_pressed("attack"):
		ability_handler.request_attack()

func get_mouse_look_vect() -> Vector3 :
	var mouseViewportPos := camera.get_viewport().get_mouse_position()
	#var ray_length := 1000
	var origin = camera.project_ray_origin(mouseViewportPos)
	var direction = camera.project_ray_normal(mouseViewportPos)
	#var target = origin + direction * ray_length
	
	# returns a vect3, or null.
	var isOnPlane = Plane(Vector3.UP).intersects_ray(origin - char_control.global_position, direction)
	var lookvect : Vector3 = Vector3.LEFT
	if isOnPlane != null:
		lookvect = isOnPlane
	
	return lookvect
















# scrollingalk;sdhjfklahweuifbsndkjl
