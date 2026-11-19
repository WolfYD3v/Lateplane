extends Control
class_name MainMenu

@onready var game_title_texture_rect: TextureRect = %GameTitleTextureRect
@onready var main_menu_clock: MainMenuClock = %MainMenuClock
@onready var background: TextureRect = %Background
@onready var black_fading: ColorRect = %BlackFading
@onready var animation_player: AnimationPlayer = %AnimationPlayer

const RUN_CONTEXT_SCENE_PATH: String = "res://scenes/run_context/run_context.tscn"
const TUTORIAL_LEVEL_SCENE_PATH: String = "res://levels/tutorial_level/tutorial_level.tscn"
const GAME_TITLE_FRAMES_DIRECTORY: String = "res://assets/images/game_title_frames/"
const BACKGROUNDS_DIRECTORY: String = "res://assets/images/main_menu_backgrounds/"

var game_title_frames: Array[String] = []
var backgrounds: Array[String] = []

func _ready() -> void:
	black_fading.hide()
	get_game_title_frames()
	update_game_title()
	get_backgrounds()
	update_background()
	main_menu_clock.seconds_updated.connect(update_game_title)
	main_menu_clock.minutes_updated.connect(update_background)

func get_game_title_frames() -> void:
	for _file: String in FilesGetter.get_files_at(GAME_TITLE_FRAMES_DIRECTORY):
		if !_file.contains(".import"): game_title_frames.append("%s%s" % [
			GAME_TITLE_FRAMES_DIRECTORY, _file
		])

func get_backgrounds() -> void:
	for _file: String in FilesGetter.get_files_at(BACKGROUNDS_DIRECTORY):
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

func play_trans() -> void:
	animation_player.play("trans_out")
	await animation_player.animation_finished
	await get_tree().create_timer(2.5).timeout

func _on_play_button_pressed() -> void:
	await play_trans()
	SceneManager.add_scene("RunContext", RUN_CONTEXT_SCENE_PATH)
	SceneManager.replace_scene("RunContext")

func _on_tutorial_button_pressed() -> void:
	await play_trans()
	SceneManager.add_scene("TutorialLevel", TUTORIAL_LEVEL_SCENE_PATH)
	SceneManager.replace_scene("TutorialLevel")

func _on_quit_button_pressed() -> void: get_tree().quit()
