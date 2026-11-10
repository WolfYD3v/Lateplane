extends BasePointTypeModifier
class_name EndPointTypeModifier

func _ready() -> void:
	parent = get_parent()
	parent.sprite.texture = override_texture
	if override_point_name != "": parent.name = override_point_name
	
	act()

func act() -> void:
	if parent:
		print("%s, Parent Found: '%s' | " % [name, parent.name], parent)
		print("Point '%s' Is An End Point" % parent.name)
		
		RunManager.player_changed_point.connect(
			func(): if RunManager.current_point == parent: RunManager.change_level()
		)
