extends Area3D
class_name StaminaRefill

@export var stamina : float = 1

func body_enter(other : Node):
	var ability_handler : AbilityHandler = NodeLib.FindChildOfCustomClass(other, AbilityHandler)
	if not ability_handler: return
	
	ability_handler.try_give_stamina_attack()

func _ready() -> void:
	body_entered.connect(body_enter)
