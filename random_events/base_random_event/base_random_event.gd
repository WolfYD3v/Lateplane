@tool
extends Control
class_name BaseRandomEvent

@onready var dm_voice_line_audio_stream_player: AudioStreamPlayer = %DMVoiceLineAudioStreamPlayer
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var body: Control = %Body
@onready var illustration_texture_rect: TextureRect = %IllustrationTextureRect

@export var location_related: BaseLevel.Locations
@export var event_name: String = "NAME":
	set(value):
		if value == "": value = "NAME"
		event_name = value
		if is_node_ready(): init_event()
@export var event_description: String = "Description":
	set(value):
		if value == "": value = "Description"
		event_description = value
		if is_node_ready(): init_event()
@export var event_illustration: Texture2D = null:
	set(value):
		event_illustration = value
		if is_node_ready(): init_event()
@export var dm_voice_line: AudioStream
@export_tool_button("Listen To DM Voice Line") var action_play_dm_voice_line = play_dm_voice_line
@export var roll_dice_for_chance: bool = false
@export var actions: Array[RandomEventAction]

const DICE_ROLLING_SCENE_PATH: String = "res://scenes/dice_rolling/dice_rolling.tscn"

func _ready() -> void:
	body.hide()
	body.modulate = Color(1.0, 1.0, 1.0, 0.0)
	init_event()
	play_dm_voice_line()
	await do_action()
	await popup()

func init_event() -> void:
	name_label.text = event_name.to_upper()
	description_label.text = event_description
	illustration_texture_rect.texture = event_illustration

func play_dm_voice_line() -> void:
	if dm_voice_line:
		dm_voice_line_audio_stream_player.stream = dm_voice_line
		dm_voice_line_audio_stream_player.play()

func do_action() -> void:
	if actions.is_empty():
		if roll_dice_for_chance: await roll_dice()
		return
	var action_picked: RandomEventAction = null
	
	if !roll_dice_for_chance: action_picked = actions.pick_random()
	else:
		var chance: int = await roll_dice()
		var a: Array[RandomEventAction] = []
		for _action: RandomEventAction in actions:
			if _action.chance_value <= chance: a.append(_action)
		if a.is_empty(): action_picked = actions.pick_random()
		else: action_picked = a.pick_random()
	
	action_picked.execute_action()

func roll_dice() -> int:
	var dice_rolling_packed_scene: PackedScene = load(DICE_ROLLING_SCENE_PATH)
	var dice_rolling_scene: DiceRolling = dice_rolling_packed_scene.instantiate()
	add_child(dice_rolling_scene)
	
	var chance: int = await dice_rolling_scene.roll_dice()
	dice_rolling_scene.queue_free()
	return chance

func popup() -> void:
	body.show()
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(body, "modulate", Color(1.0, 1.0, 1.0, 1.0), 5.0)
	await tween.finished


func _on_close_button_pressed() -> void:
	RunManager.trigger_next_point_selection.emit()
	queue_free()
