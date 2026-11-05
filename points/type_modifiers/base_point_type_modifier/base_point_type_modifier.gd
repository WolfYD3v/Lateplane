extends Node
class_name BasePointTypeModifier

@export var override_texture = null

var parent: BasePoint = null

func _ready() -> void:
	parent = get_parent()
	act()

func act() -> void: pass
