extends BasePointTypeModifier
class_name EndPointTypeModifier

func _ready() -> void:
	parent = get_parent()
	parent.sprite.texture = override_texture
	if override_point_name != "": parent.name = override_point_name
	if override_point_description != "": parent.description = override_point_description
	parent.update_name_label_text()
	
	act()

func act() -> void:
	if parent:
		print("%s, Parent Found: '%s' | " % [name, parent.name], parent)
		print("Point '%s' Is An End Point" % parent.name)
		RunManager.player_changed_point.connect(try_go_to_next_level)

func try_go_to_next_level() -> void:
	if RunManager.current_point == parent and RunManager.current_level:
		await RunManager.current_level.try_play_transition("in")
		await get_tree().create_timer(0.5).timeout
		RunManager.change_level()
