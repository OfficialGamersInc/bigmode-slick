extends Node

@export var player : CharacterController

@export var attack_stam_charges : Array[Control]
@export var move_stam_charges : Array[Control]

# DEBUG
@export var attack_label : Label
@export var move_label : Label

var attack_stam_temp : float
var move_stam_temp : float

var ability_handler : AbilityHandler

func _ready() -> void:
	if player != null :
		ability_handler = NodeLib.FindChildOfCustomClass(player, AbilityHandler, true, true)
		
		attack_stam_temp = ability_handler.stamina_attack_cur
		move_stam_temp = ability_handler.stamina_move_cur
		
	
	

func _process(_delta: float) -> void:
	if ability_handler != null :
		attack_stam_temp = ability_handler.stamina_attack_cur
		move_stam_temp = ability_handler.stamina_move_cur
		
		attack_label.text = "Attack Stamina: " + str(attack_stam_temp)
		move_label.text = "Movement Stamina: " + str(move_stam_temp)
		
		update_stam_charges()
	

func update_stam_charges() :
	for i in move_stam_charges.size() :
			move_stam_charges[i - 1].visible = false
	for j in range(floor(move_stam_temp)) :
		move_stam_charges[j].visible = true
	
	for i in attack_stam_charges.size() :
			attack_stam_charges[i - 1].visible = false
	for j in range(floor(attack_stam_temp)) :
		attack_stam_charges[j].visible = true









# eeee
