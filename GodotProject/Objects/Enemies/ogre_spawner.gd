extends Node3D

@export var ogre_packed_scene : PackedScene
#var ogre_instance

@export var spawn_cooldown : float = 10
var _spawn_timer : float = 0
var ready_to_spawn : bool = false

@export var ogre_limit : int = 5
@export var current_ogres : int

@export var spawn_positions : Array[Node3D]


func _process(delta: float) -> void:
	if ready_to_spawn == false :
		_spawn_timer += delta
		if _spawn_timer >= spawn_cooldown :
			ready_to_spawn = true
			_spawn_timer = 0
	else :
		try_spawn_ogre()


func try_spawn_ogre() :
	if get_tree().get_nodes_in_group("Enemy").size() < ogre_limit :
		
		ready_to_spawn = false
		
		var new_ogre_instance = ogre_packed_scene.instantiate()
		add_child(new_ogre_instance)
		
		current_ogres = get_tree().get_nodes_in_group("Enemy").size()
		print("Current Ogre Size: " + str(current_ogres))















# any ogres here
