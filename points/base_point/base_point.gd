extends Node2D
class_name BasePoint

signal done

@onready var sprite: Sprite2D = %Sprite
@onready var ready_for_selection_canvas_group: CanvasGroup = %ReadyForSelectionCanvasGroup
@onready var mouse_detection_area: Area2D = %MouseDetectionArea
@onready var player_detection_area: Area2D = %PlayerDetectionArea
@onready var ring_a: Sprite2D = %RingA
@onready var ring_b: Sprite2D = %RingB
@onready var background: Sprite2D = %Background
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var hover_infos_canvas_layer: CanvasLayer = %HoverInfosCanvasLayer

@export_multiline() var description: String = ""
@export var know_points: Array[BasePoint] = []
@export var end_point: bool = false
@export var night_point: bool = false

var _ready_for_selection: bool = false:
	set(value):
		_ready_for_selection = value
		if is_node_ready(): ready_for_selection_canvas_group.visible = _ready_for_selection
var selected: bool = false:
	set(value):
		selected = value
		if is_node_ready(): ready_for_selection_canvas_group.visible = selected
var visited: bool = false:
	set(value):
		visited = value
		if visited and is_node_ready(): update_background()
var _mouse_in: bool = false:
	set(value):
		_mouse_in = value
		if is_node_ready() and _ready_for_selection or visited: hover_infos_canvas_layer.visible = _mouse_in
		else: hover_infos_canvas_layer.visible = false

func _ready() -> void:
	if end_point: scale *= 1.5
	_mouse_in = false
	_ready_for_selection = false
	selected = false
	update_name_label_text()
	update_background()
	a()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _mouse_in and _ready_for_selection:
			try_toggle_next_point_selection(false)
			update_current_point()
			visited = true
			done.emit()
			MoneyManager.add_money(50)

func update_name_label_text() -> void:
	var regex: RegEx = RegEx.create_from_string("Point[0-9]{1,5}")
	var regex_match: RegExMatch = regex.search(name)
	var spliter: String = "Point"
	if regex_match: spliter = regex_match.get_string(0)
	
	name_label.text = "%s Point" % name.split(spliter, false)[0]
	description_label.text = description

func update_current_point() -> void:
	print("Know Points on Point '%s': " % name, know_points)
	RunManager.current_point = self
	selected = true

func update_background() -> void:
	background.visible = visited
	if not visited: background.modulate = Color(1.0, 1.0, 1.0, 0.0)
	else:
		var tween: Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(
			background, "modulate",
			Color(1.0, 1.0, 1.0, 1.0), 1.5
		)

func try_toggle_next_point_selection(enabled: bool = true) -> void:
	if know_points.is_empty(): return
	
	if RunManager.current_point:
		for _point: BasePoint in RunManager.current_point.know_points: _point._ready_for_selection = false
		if RunManager.current_point != self or enabled: RunManager.current_point.selected = false
	
	for _point: BasePoint in know_points: _point._ready_for_selection = enabled

func get_player_position_on_point() -> Vector2:
	return Vector2(
		global_position.x,
		global_position.y - 75.0
	)

func a():
	ring_a.position = Vector2(randf_range(0.0, 5.0), randf_range(0.0, 5.0))
	ring_b.position = Vector2(randf_range(0.0, 5.0), randf_range(0.0, 5.0))
	await get_tree().create_timer(0.75).timeout
	a()

func _process(delta: float) -> void:
	sprite.rotate(deg_to_rad(20.0 * delta))
	ring_a.rotate(deg_to_rad(55.0 * delta))
	ring_b.rotate(deg_to_rad(-70.0 * delta))

func _on_mouse_detection_area_mouse_entered() -> void: _mouse_in = true
func _on_mouse_detection_area_mouse_exited() -> void: _mouse_in = false
