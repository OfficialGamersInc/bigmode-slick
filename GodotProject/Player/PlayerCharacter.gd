extends CharacterController
class_name PlayerCharacter

@export var _control_enabled = false
#@export var camera_rig : FPSCamera

@onready var AbilityManager = find_child("AbilityManager")

## not sure what else to call this. Rotation component is for the camera,
## position is for the player character.
#func set_friendly_transform(pos : Vector3, lookVect : Vector3):
	#global_position = pos
	#camera_rig.SetLookVector(lookVect)

## not sure what else to call this. Rotation component is for the camera,
## position is for the player character.
#func get_friendly_transform() -> Transform3D:
	#var trans = Transform3D(Basis.looking_at(camera_rig.LookVector), global_position)
	#return trans

func set_control_enabled(control_enabled : bool):
	#if _control_enabled == control_enabled: return
	
	_control_enabled = control_enabled
	move_vector = Vector3()
	#camera_rig.visible = control_enabled

func _process(_delta: float) -> void:
	if not _control_enabled: return
	
	#if is_wall_running:
		#camera_rig.SubjectLeanDirection = get_wall_normal()
	#else:
		#camera_rig.SubjectLeanDirection = Vector3.ZERO
	#
	#look_vector = camera_rig.Pivot.global_basis * Vector3.FORWARD
	
	var input = Input.get_vector(\
		"move_left", "move_right", "move_forward", "move_backward")
	var input_vector3 = Vector3(input.x, 0, input.y)
	var cameraFlattenedTransform : Basis = Basis.looking_at(
		project_on_plane(camera.global_basis * Vector3.FORWARD, up_direction),
		up_direction
	)
	if (camera.global_basis * up_direction).y < 0: input_vector3 *= -1
	move_vector = cameraFlattenedTransform * input_vector3
	
	jump_held = Input.is_action_pressed("jump")
