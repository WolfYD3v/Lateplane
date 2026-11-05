extends BasePointTypeModifier
class_name TestPointTypeModifier

func act() -> void:
	if parent: print("%s, Parent Found: '%s' | " % [name, parent.name], parent)
