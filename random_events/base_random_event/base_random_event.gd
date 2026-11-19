@tool
extends Control
class_name BaseRandomEvent

@onready var dm_voice_line_audio_stream_player: AudioStreamPlayer = %DMVoiceLineAudioStreamPlayer
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var illustration_texture_rect: TextureRect = %IllustrationTextureRect
@onready var card_texture_rect: TextureRect = %CardTextureRect
@onready var card_animation_player: AnimationPlayer = %CardAnimationPlayer
@onready var alert_text_label: Label = %AlertTextLabel
@onready var alert_section_animation_player: AnimationPlayer = %AlertSectionAnimationPlayer
@onready var front_face_sub_viewport: SubViewport = %FrontFaceSubViewport

@export var is_night_event: bool = false
@export var location_related: BaseLevel.Locations
@export var event_name: String = "NAME":
	set(value):
		if value == "": value = "NAME"
		event_name = value
		if is_node_ready(): init_event()
@export_multiline() var event_description: String = "Description":
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
@export var alert_section_messages: Array[String] = [
	"Il se passe quelque chose !",
	"Laisse moi tirer une carte...",
	"Que va t-il t'arriver ?",
	"Hold on cowboy !",
	"Là ça devient intéressant"
]

const DICE_ROLLING_SCENE_PATH: String = "res://scenes/dice_rolling/dice_rolling.tscn"

func _ready() -> void:
	card_texture_rect.hide()
	init_event()
	play_dm_voice_line()
	await popup()

func _input(event: InputEvent) -> void:
	front_face_sub_viewport.push_input(event, true)

func init_event() -> void:
	name_label.text = event_name.to_upper()
	description_label.text = event_description
	illustration_texture_rect.texture = event_illustration

func pick_alert_text() -> void: alert_text_label.text = alert_section_messages.pick_random()

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
		await get_tree().create_timer(DiceRolling.TIME_TO_READ_NB).timeout
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
	await get_tree().create_timer(DiceRolling.TIME_TO_READ_NB).timeout
	dice_rolling_scene.queue_free()
	return chance

func popup() -> void:
	pick_alert_text()
	if !is_night_event:
		alert_section_animation_player.play("normal")
		await alert_section_animation_player.animation_finished
		await get_tree().create_timer(1.5).timeout
	await do_action()
	card_texture_rect.show()
	card_animation_player.play("turn_card")
	await card_animation_player.animation_finished


func _on_close_button_pressed() -> void:
	if card_animation_player.is_playing(): card_animation_player.speed_scale = 15.0
	else:
		if is_night_event: RunManager.days_count -= 1
		RunManager.trigger_next_point_selection.emit()
		queue_free()
