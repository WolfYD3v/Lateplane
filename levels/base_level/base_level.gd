extends Node2D
class_name BaseLevel

enum Locations {
	PARIS,
	LONDON,
	TOKYO
}

@onready var map_container: Node2D = %MapContainer
@onready var points_container: Node2D = %PointsContainer
@onready var player: Player = %Player

@export var dm_voice_line: AudioStream = null
@export_range(5, 6, 1, "or_greater") var max_days_count: int = 5
@export var location: Locations = Locations.PARIS

var has_end_point: BasePoint = null
var first_point: BasePoint = null

func _ready() -> void:
	RunManager.current_level = self
	RunManager.current_point_updated.connect(
		func(): player.move(RunManager.current_point.get_player_position_on_point())
	)
	RunManager.trigger_next_point_selection.connect(
		func(): RunManager.current_point.try_toggle_next_point_selection()
	)
	RunManager.days_count = max_days_count
	init_points()
	
	first_point = points_container.get_child(0)
	if first_point:
		first_point.visited = true
		first_point.update_current_point()
		player.move(RunManager.current_point.get_player_position_on_point(), true)
		first_point.try_toggle_next_point_selection()

func get_all_points() -> Array[Node]: return points_container.get_children()

func init_points() -> void:
	var points: Array[Node] = get_all_points()
	points.remove_at(0)
	for _point: Node in points:
		if _point is EmptyPoint:
			RunManager.current_point = _point
			print(_point.night_point)
			assert(not(_point.end_point and has_end_point), "An End Point Has Already Be Seted Up, Point '%s' Cannot Be An End Point !" % _point.name)
			if _point.end_point and not has_end_point: has_end_point = _point
			_point.try_asign_type()
	
	assert(has_end_point, "No End Point Has Been Found, The Level Is Incomplete !")
