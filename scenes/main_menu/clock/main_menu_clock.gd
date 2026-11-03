extends Node2D
class_name MainMenuClock

signal seconds_updated
signal minutes_updated

@onready var hours_arrow: Node2D = %HoursArrow
@onready var minutes_arrow: Node2D = %MinutesArrow
@onready var seconds_arrow: Node2D = %SecondsArrow
@onready var audio_stream_player: AudioStreamPlayer2D = %AudioStreamPlayer
@onready var outline: MeshInstance2D = %Outline
@onready var base_text_mesh_instance: MeshInstance2D = %BaseTextMeshInstance
@onready var numbers_canvas_group: CanvasGroup = %NumbersCanvasGroup

var next_second_minute_rotation: float = deg_to_rad(360.0 / 60.0)
var next_hour_rotation: float = deg_to_rad(360.0 / 12)
var seconds: int = 0
var minutes: int = 0
var hours: int = 0

func _ready() -> void:
	base_text_mesh_instance.hide()
	init_clock()
	update_time()
	seconds_updated.connect(
		func(): rotation = deg_to_rad(randf_range(-4.5, 4.5))
	)

func init_numbers() -> void:
	var path_curve: Curve2D = %Path2D.curve
	var numbers: Array = [12]
	numbers.append_array(range(1, path_curve.point_count))
	for loop: int in range(numbers.size()):
		var idx: int = numbers[loop]
		var new_txt_mesh_inst: MeshInstance2D = base_text_mesh_instance.duplicate()
		new_txt_mesh_inst.mesh = new_txt_mesh_inst.mesh.duplicate()
		new_txt_mesh_inst.mesh.text = str(idx)
		numbers_canvas_group.add_child(new_txt_mesh_inst)
		new_txt_mesh_inst.position = path_curve.get_point_position(loop)
		new_txt_mesh_inst.show()
	
	base_text_mesh_instance.queue_free()
	%Path2D.queue_free()


func _process(delta: float) -> void:
	outline.rotate(deg_to_rad(25.0 * delta))
	%Body.rotate(deg_to_rad(-10.0 * delta))

func init_clock() -> void:
	var current_time: Dictionary = Time.get_time_dict_from_system(true)
	seconds = current_time.second
	minutes = current_time.minute
	hours = current_time.hour
	if hours >= 12: while hours >= 12: hours -= 12
	
	var e: float = 360.0 / 60.0
	seconds_arrow.rotation_degrees = -90.0 + (float(seconds) * e)
	minutes_arrow.rotation_degrees = -90.0 + (float(minutes) * e)
	hours_arrow.rotation_degrees = -90.0 - (float(hours + 1) * (5.0 * e))
	
	init_numbers()


func update_time() -> void:
	while true:
		seconds += 1
		seconds_updated.emit()
		seconds_arrow.rotate(next_second_minute_rotation)
		play_sfx()
		
		if seconds >= 60:
			seconds = 0
			minutes += 1
			minutes_updated.emit()
			minutes_arrow.rotate(next_second_minute_rotation)
			play_sfx()
		if minutes >= 60:
			minutes = 0
			hours += 1
			hours_arrow.rotate(next_hour_rotation)
			play_sfx()
		if hours >= 12: hours = 0
		
		await get_tree().create_timer(1.0).timeout

func play_sfx() -> void:
	audio_stream_player.pitch_scale = randf_range(1.0, 1.2)
	audio_stream_player.play()
