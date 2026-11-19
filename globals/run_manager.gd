extends Node

signal current_point_updated
signal days_count_updated
signal player_changed_point
signal trigger_next_point_selection

const LEVELS_DIRECTORY_PATH: String = "res://levels/collection/"
const MAIN_MENU_SCENE_PATH: String = "res://scenes/main_menu/main_menu.tscn"
const SHOPS_DIRECTORY: String = "res://shops/collection/"

var _current_level_file_name: String = ""
var _all_levels: Array[String] = []
var shops: Array[String] = []
var shops_placed_count: int = 0

var current_point: BasePoint = null:
	set(value):
		current_point = value
		current_point_updated.emit()
var current_level: BaseLevel = null

var days_count: int = 0:
	set(value):
		days_count = clampi(value, 0, 999)
		days_count_updated.emit()

func start_new_run() -> void:
	MoneyManager.money = 0
	InventoryManager.clear_items()
	get_shops()
	get_all_levels()
	change_level()

func change_level() -> void:
	if _all_levels.is_empty(): run_finished()
	else:
		get_shops()
		set_random_current_level()
		if SceneManager.has_scene("Map"): SceneManager.remove_scene("Map")
		SceneManager.add_scene("Map", LEVELS_DIRECTORY_PATH + _current_level_file_name)
		SceneManager.replace_scene("Map")

func get_levels_count() -> int: return _all_levels.size()

func get_all_levels() -> void:
	_all_levels = FilesGetter.get_files_at(LEVELS_DIRECTORY_PATH)
	print("Levels Fetched: ", _all_levels, "\n")

func set_random_current_level() -> void:
	var random_idx: int = randi_range(0, get_levels_count() - 1)
	_current_level_file_name = _all_levels.pop_at(random_idx)
	print("Level Selected: ", _current_level_file_name)
	print("Levels Remaining: ", _all_levels)

func get_shops() -> void:
	shops = []
	shops_placed_count = 0
	for _file: String in FilesGetter.get_files_at(SHOPS_DIRECTORY):
		if _file.ends_with(".tscn"): shops.append("%s%s" % [SHOPS_DIRECTORY, _file])
	print("RunManager - Shops Found: ", shops)

func run_finished() -> void:
	if !SceneManager.has_scene("MainMenu"): SceneManager.add_scene("MainMenu", MAIN_MENU_SCENE_PATH)
	SceneManager.replace_scene("MainMenu")
