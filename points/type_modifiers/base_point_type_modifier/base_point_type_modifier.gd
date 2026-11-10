extends Node
class_name BasePointTypeModifier

@export var override_point_name: String = ""
@export var override_texture: Texture2D = null

const RANDOM_EVENTS_COLLECTION_PATH: String = "res://random_events/collection/"

var parent: BasePoint = null
var right_random_events_files: Array[String] = []

func _ready() -> void:
	parent = get_parent()
	parent.sprite.texture = override_texture
	if override_point_name != "": parent.name = override_point_name
	
	get_right_random_events()
	act()

func get_right_random_events() -> void:
	for _file: String in DirAccess.get_files_at(RANDOM_EVENTS_COLLECTION_PATH):
		if _file.ends_with(".tscn"):
			var event_scene: BaseRandomEvent = load_event_file("%s%s" % [
				RANDOM_EVENTS_COLLECTION_PATH, _file
			])
			if RunManager.current_point and event_scene.is_night_event == RunManager.current_point.night_point:
				if RunManager.current_level and event_scene.location_related == RunManager.current_level.location:
					right_random_events_files.append("%s%s" % [RANDOM_EVENTS_COLLECTION_PATH, _file])
	print(right_random_events_files)

func load_event_file(path: String) -> BaseRandomEvent:
	var event_packed_scene: PackedScene = load(path)
	return event_packed_scene.instantiate()

func act() -> void: pass
