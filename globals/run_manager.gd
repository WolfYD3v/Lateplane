extends Node

const LEVELS_DIRECTORY_PATH: String = "res://levels/collection/"

var _current_level: String = ""
var _all_levels: Array = []

func start_new_run() -> void:
	get_all_levels()
	change_level()

func change_level() -> void:
	if _all_levels.is_empty(): run_finished()
	else:
		set_random_current_level()
		if SceneManager.has_scene("Map"): SceneManager.remove_scene("Map")
		SceneManager.add_scene("Map", LEVELS_DIRECTORY_PATH + _current_level)
		SceneManager.replace_scene("Map")

func get_levels_count() -> int: return _all_levels.size()

func get_all_levels() -> void:
	_all_levels = Array(DirAccess.get_files_at(LEVELS_DIRECTORY_PATH))
	print("Levels Fetched: ", _all_levels, "\n")

func set_random_current_level() -> void:
	var random_idx: int = randi_range(0, get_levels_count() - 1)
	_current_level = _all_levels.pop_at(random_idx)
	print("Level Selected: ", _current_level)
	print("Levels Remaining: ", _all_levels)

func run_finished() -> void:
	print("\nRun Finished !")                   # TEMP
	await get_tree().create_timer(0.25).timeout # TEMP
	get_tree().quit()                           # TEMP
