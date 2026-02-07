extends CanvasLayer

@export var main_level_to_load : PackedScene
var level_instance

func _ready() -> void:
	level_instance = main_level_to_load.instantiate()

func _on_button_pressed() -> void:
	add_sibling(level_instance)
	
	self.hide()
