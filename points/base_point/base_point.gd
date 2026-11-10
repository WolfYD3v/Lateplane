extends Node2D
class_name BasePoint

signal done

@onready var sprite: Sprite2D = %Sprite
@onready var ready_for_selection_canvas_group: CanvasGroup = %ReadyForSelectionCanvasGroup
@onready var mouse_detection_area: Area2D = %MouseDetectionArea
@onready var player_detection_area: Area2D = %PlayerDetectionArea

@export var know_points: Array[BasePoint] = []
@export var end_point: bool = false
@export var night_point: bool = false

var _ready_for_selection: bool = false:
	set(value):
		_ready_for_selection = value
		ready_for_selection_canvas_group.visible = _ready_for_selection
var selected: bool = false:
	set(value):
		selected = value
		ready_for_selection_canvas_group.visible = selected

var _mouse_in: bool = false

func _ready() -> void:
	_ready_for_selection = false
	selected = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _mouse_in and _ready_for_selection:
			try_toggle_next_point_selection(false)
			update_current_point()
			done.emit()
			MoneyManager.add_money(50)

func update_current_point() -> void:
	print("Know Points on Point '%s': " % name, know_points)
	RunManager.current_point = self
	selected = true

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

func _process(delta: float) -> void:
	ready_for_selection_canvas_group.get_child(0).rotate(deg_to_rad(55.0 * delta))
	ready_for_selection_canvas_group.get_child(1).rotate(deg_to_rad(-70.0 * delta))

func _on_mouse_detection_area_mouse_entered() -> void: _mouse_in = true
func _on_mouse_detection_area_mouse_exited() -> void: _mouse_in = false
