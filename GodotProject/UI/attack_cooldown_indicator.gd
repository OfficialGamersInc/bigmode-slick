extends Node

@export var player : CharacterController

@export var attack_cooldown_bar : ProgressBar

var slash_ability : Ability_Slash

func _ready() -> void:
	if player != null :
		slash_ability = NodeLib.FindChildOfCustomClass(player, Ability_Slash, true, true)
		
		
		
		attack_cooldown_bar.value = slash_ability.attackTimer / slash_ability.attackCooldown
	

func _process(delta: float) -> void:
	print(str(slash_ability.canAttack))
	#print(str(slash_ability.attackTimer / slash_ability.attackCooldown))
	
	attack_cooldown_bar.value = slash_ability.attackTimer / slash_ability.attackCooldown
	
