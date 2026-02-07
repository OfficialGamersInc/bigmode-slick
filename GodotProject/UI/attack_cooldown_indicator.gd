extends Node

@export var player : CharacterController
@export var attack_cooldown_bar : ProgressBar
@export var grayout : ColorRect

var ability_handler : AbilityHandler
var slash_ability : Ability_Slash

enum CooldownBarStates {Grayed, Highlighted, Crit}
var AbleAttackState : CooldownBarStates

func _ready() -> void:
	if player != null :
		ability_handler = NodeLib.FindChildOfCustomClass(player, AbilityHandler, true, true)
		slash_ability = NodeLib.FindChildOfCustomClass(player, Ability_Slash, true, true)
		
		attack_cooldown_bar.value = slash_ability.attackTimer / slash_ability.attackCooldown
	

func _process(_delta: float) -> void:
	if ability_handler.stamina_attack_cur > 1 and AbleAttackState != CooldownBarStates.Highlighted :
		AbleAttackState = CooldownBarStates.Highlighted
		grayout.visible = false
		
	elif ability_handler.stamina_attack_cur < 1 and AbleAttackState != CooldownBarStates.Grayed:
		AbleAttackState = CooldownBarStates.Grayed
		grayout.visible = true
		
	
	if slash_ability.canAttack :
		attack_cooldown_bar.value = 1
	else :
		attack_cooldown_bar.value = slash_ability.attackTimer / slash_ability.attackCooldown
	
