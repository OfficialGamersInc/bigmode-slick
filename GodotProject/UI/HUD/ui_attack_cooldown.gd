extends TextureRect

var player : PlayerCharacter
var ability_handler : AbilityHandler
var slash_ability : Ability_Slash

enum CooldownBarStates {Grayed, Highlighted, Crit}
var AbleAttackState : CooldownBarStates

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	ability_handler = NodeLib.FindChildOfCustomClass(player, AbilityHandler, true, true)
	slash_ability = NodeLib.FindChildOfCustomClass(player, Ability_Slash, true, true)

func _process(_delta: float) -> void:
	print(slash_ability.attackTimer / slash_ability.attackCooldown)
	material.set("shader_parameter/fill_alpha", slash_ability.attackTimer / slash_ability.attackCooldown)
	#set_instance_shader_parameter("shader_parameter/fill_alpha", slash_ability.attackTimer / slash_ability.attackCooldown)
