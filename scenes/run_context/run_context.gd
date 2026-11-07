extends Node3D
class_name RunContext

@onready var image_texture_rect: TextureRect = %ImageTextureRect
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var menu: Control = %Menu
@onready var menu_buttons: Control = %Buttons
@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var mesh_instance: MeshInstance3D = %MeshInstance
@onready var _3d_view_rigid_body: RigidBody3D = %"3DViewRigidBody"

@export var sequences: Array[RunContextSequence] = []

func _ready() -> void: pass

func play_sequences() -> void:
	for _sequence: RunContextSequence in sequences:
		image_texture_rect.texture = _sequence.image
		audio_stream_player.stream = _sequence.voice_line
		if audio_stream_player.stream:
			audio_stream_player.play()
			await audio_stream_player.finished
			await get_tree().create_timer(0.5).timeout
		else: await get_tree().create_timer(_sequence.freezing_duration).timeout

func stop() -> void:
	SceneManager.remove_scene("RunContext")
	RunManager.start_new_run()

func show_title_card() -> void:
	menu_buttons.queue_free()
	await get_tree().create_timer(5.0).timeout

func a() -> void:
	canvas_layer.hide()
	
	var image: Image = get_viewport().get_texture().get_image()
	var game_window_texture: ImageTexture = ImageTexture.create_from_image(image)
	var material: StandardMaterial3D = mesh_instance.get_surface_override_material(0) as StandardMaterial3D
	if !material:
		material = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(0, material)
	material.albedo_texture = game_window_texture
	
	await get_tree().create_timer(1.0).timeout
	_3d_view_rigid_body.freeze = false
	_3d_view_rigid_body.apply_central_impulse(Vector3(-1.5, 2.5, -1.5))
	$CSGCombiner3D.queue_free()


func _on_get_context_button_pressed() -> void:
	await show_title_card()
	menu.queue_free()
	await play_sequences()
	a()

func _on_skip_button_pressed() -> void: stop()


func _on_area_body_entered(_body: Node3D) -> void: stop()
