extends BasePoint
class_name EmptyPoint

@export var type_modifier: BasePointTypeModifier = null

const TYPE_MODIFIERS_DIRECTORY: String = "res://points/type_modifiers/"
const END_POINT_TYPE_MODIFIER_PATH: String = "res://points/type_modifiers/end_point_type_modifier/end_point_type_modifier.tscn"

var _type_modifiers: Array[String] = []

func _ready() -> void:
	super()
	get_all_type_modifiers()

func get_all_type_modifiers() -> void:
	for file: String in DirAccess.get_files_at(TYPE_MODIFIERS_DIRECTORY):
		if file.ends_with(".tscn"): _type_modifiers.append(file)

func try_asign_type() -> void:
	var type_modifier_path: String = ""
	
	if end_point: type_modifier_path = END_POINT_TYPE_MODIFIER_PATH
	elif randf_range(0.0, 1.0) > 0.15:
		type_modifier_path = "%s%s" % [
			TYPE_MODIFIERS_DIRECTORY, _type_modifiers.pick_random()
		]
	else: pass
	
	if type_modifier_path != "":
		var packed_type_modifier: PackedScene = load(type_modifier_path)
		add_child(packed_type_modifier.instantiate())
