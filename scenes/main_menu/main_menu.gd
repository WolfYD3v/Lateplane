extends Control
class_name MainMenu

@onready var game_title_texture_rect: TextureRect = %GameTitleTextureRect
@onready var main_menu_clock: MainMenuClock = %MainMenuClock
@onready var background: TextureRect = %Background

const GAME_TITLE_FRAMES_DIRECTORY: String = "res://assets/images/game_title_frames/"
const BACKGROUNDS_DIRECTORY: String = "res://assets/images/main_menu_backgrounds/"

var game_title_frames: Array[String] = []
var backgrounds: Array[String] = []

func _ready() -> void:
	get_game_title_frames()
	get_backgrounds()
	main_menu_clock.seconds_updated.connect(update_game_title)
	main_menu_clock.minutes_updated.connect(update_background)

func get_game_title_frames() -> void:
	for _file: String in DirAccess.get_files_at(GAME_TITLE_FRAMES_DIRECTORY):
		if !_file.contains(".import"): game_title_frames.append("%s%s" % [
			GAME_TITLE_FRAMES_DIRECTORY, _file
		])

func get_backgrounds() -> void:
	for _file: String in DirAccess.get_files_at(BACKGROUNDS_DIRECTORY):
		if !_file.contains(".import"): backgrounds.append("%s%s" % [
			BACKGROUNDS_DIRECTORY, _file
		])

func update_game_title() -> void:
	game_title_texture_rect.rotation = deg_to_rad(randf_range(-7.5, 7.5))
	var next_frame: String = ""
	if randf_range(0.0, 1.0) >= 0.005:
		if game_title_frames.is_empty(): return
		next_frame = game_title_frames.pick_random()
	else: next_frame = "res://assets/images/game_logo.png"
	
	game_title_texture_rect.texture = load(next_frame)

func update_background() -> void:
	if backgrounds.is_empty(): return
	var next_backgound: String = game_title_frames.pick_random()
	
	background.texture = load(next_backgound)

func _on_play_button_pressed() -> void: RunManager.start_new_run()

func _on_quit_button_pressed() -> void: get_tree().quit()
