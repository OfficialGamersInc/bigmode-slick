extends Node3D
class_name HitBox

@export var Damage : float = 25
@export var Knockback : float = 10
@export var IgnoreParent : Node

func BodyEntered(other : Node3D):
	if IgnoreParent and (other == IgnoreParent or IgnoreParent.is_ancestor_of(other)):
		return
	
	var health : HealthHandler = other.find_child("HealthHandler")
	if(not health): return
	var damageOrigin : Vector3 = global_position - other.global_position
	health.change_health(-Damage, damageOrigin.normalized(), Knockback)
	
