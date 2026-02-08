extends Area3D
class_name StaminaRefill

@export var stamina : float = 1
@export var always_active : bool = true

func body_enter(other : Node):
	if not always_active: return
	trigger_body(other)

func trigger_body(other : Node):
	var ability_handler : AbilityHandler = NodeLib.FindChildOfCustomClass(other, AbilityHandler)
	if not ability_handler: return
	
	ability_handler.try_give_stamina_attack()

func test():
	for body : Node in get_overlapping_bodies():
		trigger_body(body)

func _ready() -> void:
	body_entered.connect(body_enter)
