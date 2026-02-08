extends Ability
class_name Ability_Slash

@onready var main_level: Node3D = char_control.get_parent() #$"../../.."

@export var cam: Camera3D

@export var slash_hit_box: Area3D
var slash_effect := preload("res://Art/Effects/slash_VFX.tscn")
var slash_effect_instance : GPUParticles3D

@export var attackCooldown : float = 0.5
var attackTimer : float = 0
var canAttack : bool

@export var damage : float = 1
@export var knockback : float = 1

signal mousePosSignal(Vector3)
signal on_attack_fired

var mouseWorldPos : Vector3

var resetCooldown : float = 0.5
var resetTimer : float = 0

enum Look_State {Movement, Target}
@export var current_Look_State : Look_State



#func _input(event) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		#mouseWorldPos = get_mouse_world_pos()

#func _unhandled_input(_event) :
	#if not enabled: return
	#
	#if Input.is_action_just_pressed("attack") :
		#
		#print("CLICK")
		#mouseWorldPos = get_mouse_world_pos()
		#mousePosSignal.emit(mouseWorldPos)
		#
		#try_attack()
	#

func _ready() -> void:
	ability_handler.attack_requested.connect(try_attack)


func _process(delta: float) -> void:
	if not enabled: return
	
	if (main_level.enableDebug) : DebugDraw.draw_line_relative_thick(mouseWorldPos, Vector3.UP, 2, Color.WHITE)
	
	
	if canAttack == false and attackTimer > attackCooldown :
		attackTimer = 1
		canAttack = true
	elif canAttack == false :
		attackTimer += delta
	
	
	if resetTimer > resetCooldown :
		resetTimer = 0
		mouseWorldPos = Vector3.ZERO
		mousePosSignal.emit(mouseWorldPos)
	else :
		resetTimer += delta

func get_mouse_world_pos() -> Vector3 :
	var mouseViewportPos := cam.get_viewport().get_mouse_position()
	var ray_length := 1000
	var origin = cam.project_ray_origin(mouseViewportPos)
	var target = origin + cam.project_ray_normal(mouseViewportPos) * ray_length
	
	var physicsSpace := get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = origin
	ray_query.to = target
	var raycast_result := physicsSpace.intersect_ray(ray_query)
	
	#print(raycast_result)
	
	if !raycast_result.is_empty() :
		return raycast_result["position"]
	else :
		return Vector3.ZERO


func try_attack() :
	if canAttack:
		if not ability_handler.try_use_stamina_attack() :
			return
		
		attackTimer = 0
		canAttack = false
		
		on_attack_fired.emit()
		checkHit()
		slash_effects()


func slash_effects() :
	slash_effect_instance = slash_effect.instantiate()
	add_child(slash_effect_instance)
	slash_effect_instance.emitting = true

func impact_effects() :
	pass
	# Impact particle effects

func checkHit() :
	var detectedBodies : Array[Node3D]
	detectedBodies = slash_hit_box.get_overlapping_bodies()
	print("BODIES: " + str(detectedBodies))
	
	if detectedBodies.is_empty() :
		pass
	else :
		print(detectedBodies.size())
		for i in detectedBodies.size() :
			var health : HealthHandler = detectedBodies[i].get_node_or_null("HealthHandler")
			var target_pos = detectedBodies[i].global_position;
			var to_target_pos = -(target_pos - global_position * Vector3(1,0,1)).normalized()
			if health != null :
				health.change_health(-1 * damage, to_target_pos, knockback)
				print("Detected HealthBehavior in: " + str(detectedBodies[i].name))
				impact_effects() # I think whats hit should handle effects of being hit
			
			#if detectedBodies[i].find_child("HealthBehavior") :
			#	print("Detected HealthBehavior in: " + str(detectedBodies[i].name))
	
