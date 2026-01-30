extends Node
class_name HealthHandler

@export var health_max : float = 99
## Set to -1 to spawn with health_max health.
@export var health : float = -1:
	set(newValue):
		var delta = newValue - health
		health = newValue
		
		health_changed.emit(delta)
	
		if can_die and health <= 0 and not dead:
			dead = true
			died.emit(delta)
			if destroy_on_death: get_parent().queue_free()
## Health regeneration per second
@export var health_per_second : float = 0
@export var destroy_on_death : bool = true
@export var can_die : bool = true

var dead = false
var last_healed = -100

signal died
signal health_changed

func change_health(health_delta : float) -> void:
	#health += health_delta
	health = clampf(health + health_delta, 0, health_max)
	
	#health_changed.emit(health_delta)
	#
	#if health <= 0 and not dead:
		#dead = true
		#died.emit(health_delta)
		#if destroy_on_death: get_parent().queue_free()

func _ready() -> void:
	if health <= -1: health = health_max

func _process(_delta: float) -> void:
	if health_per_second == 0: return
	if (can_die and dead): return
	if health >= health_max: return
	
	var cur_sec = floor(ScaledTime.CurrentTime)
	if cur_sec > last_healed:
		last_healed = cur_sec
		change_health(health_per_second)
