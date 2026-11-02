extends Node2D
class_name BaseLevel

@onready var map_container: Node2D = $MapContainer
@onready var points_container: Node2D = $PointsContainer

func _ready() -> void:
	$CanvasLayer/Label.text = "Level(s) Remaining: %s" % [RunManager.get_levels_count() + 1]
# TEMP
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): RunManager.change_level()

func get_all_points() -> Array[Node]: return points_container.get_children()

func init_points() -> void:
	var points: Array[Node] = get_all_points()
	for _point: Node in points:
		if _point is EmptyPoint: _point.try_asign_type()
