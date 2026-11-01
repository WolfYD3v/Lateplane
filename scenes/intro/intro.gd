extends Control
class_name Intro

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer

const MAIN_MENU_SCENE_PATH: String = "res://scenes/main_menu/main_menu.tscn"

func _ready() -> void:
	video_stream_player.play()
	await video_stream_player.finished
	
	SceneManager.add_scene("MainMenu", MAIN_MENU_SCENE_PATH)
	SceneManager.remove_scene("Intro")
	SceneManager.replace_scene("MainMenu")
