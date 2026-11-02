extends Control
class_name MainMenu

@onready var game_title_texture_rect: TextureRect = $VBoxContainer/GameTitleTextureRect

const GAME_TITLE_FRAMES_DIRECTORY: String = "res://assets/images/game_title_frames/"
const GAME_LOGO_FILE_PATH: String = "res://assets/images/game_logo.png"

var game_title_frames: PackedStringArray = []

func _ready() -> void:
	get_game_title_frames()
	animate_game_title()

func get_game_title_frames() -> void:
	for _file: String in DirAccess.get_files_at(GAME_TITLE_FRAMES_DIRECTORY):
		if !_file.contains(".import"): game_title_frames.append(_file)

func animate_game_title() -> void:
	for _frame: String in game_title_frames:
		if randf_range(0.0, 1.0) > 0.1: game_title_texture_rect.texture = load("%s%s" % [
			GAME_TITLE_FRAMES_DIRECTORY, _frame
		])
		else: game_title_texture_rect.texture = load(GAME_LOGO_FILE_PATH)
		await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	animate_game_title()

func _on_button_pressed() -> void:
	RunManager.start_new_run()
