extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player : CharacterController = get_tree().get_nodes_in_group("Player")[0]
	
	print(str(player))
	
	var ability_handler = NodeLib.FindChildOfCustomClass(player, AbilityHandler, true, true)
	ability_handler.connect("on_use_attack_stam", update_attack_stam())
	ability_handler.connect("on_use_move_stam", update_move_stam())
	print(str(ability_handler))
	

func update_attack_stam() :
	pass
	

func update_move_stam() :
	pass
	
