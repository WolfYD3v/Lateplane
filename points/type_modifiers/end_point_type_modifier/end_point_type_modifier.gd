extends BasePointTypeModifier
class_name EndPointTypeModifier

func act() -> void:
	if parent:
		print("%s, Parent Found: '%s' | " % [name, parent.name], parent)
		print("Point '%s' Is An End Point" % parent.name)
		
		RunManager.current_point_updated.connect(
			func(): if RunManager.current_point == parent: RunManager.change_level()
		)
