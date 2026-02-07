extends Node

@export var stamina_bars_move : Array[Control];
@export var stamina_bars_attack : Array[Control];

var player : PlayerCharacter
var ability_handler : AbilityHandler

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	ability_handler = NodeLib.FindChildOfCustomClass(player, AbilityHandler, true, true)
	
	ability_handler.stamina_updated_attack.connect(update_attack_stam)
	ability_handler.stamina_updated_move.connect(update_move_stam)
	

func update_attack_stam() :
	set_stam_bars(stamina_bars_attack, ability_handler.stamina_attack_cur)
	

func update_move_stam() :
	set_stam_bars(stamina_bars_move, ability_handler.stamina_move_cur)
	

func set_stam_bars(bars : Array[Control], stam : float):
	var cur_stam = floor(stam)
	for i in bars.size():
		var elem : Control = bars[i];
		elem.visible = i < cur_stam













# bruh
