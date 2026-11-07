extends Node2D
class_name BaseLevel

@onready var map_container: Node2D = %MapContainer
@onready var points_container: Node2D = %PointsContainer
@onready var player: Player = %Player

@export var dm_voice_line: AudioStream = null
@export_range(5, 6, 1, "or_greater") var max_days_count: int = 5

var has_end_point: BasePoint = null

func _ready() -> void:
	$CanvasLayer/Control/DiceRolling.hide()
	$CanvasLayer/Control/DiceRolling.process_mode = Node.PROCESS_MODE_DISABLED
	#await get_tree().create_timer(1.5).timeout
	#$CanvasLayer/Control/DiceRolling.show()
	#$CanvasLayer/Control/DiceRolling.process_mode = Node.PROCESS_MODE_INHERIT
	
	RunManager.current_point_updated.connect(
		func(): player.position = RunManager.current_point.global_position
	)
	RunManager.days_count = max_days_count
	init_points()
	
	var first_point: BasePoint = points_container.get_child(0)
	if first_point:
		first_point.update_current_point()
		await get_tree().create_timer(3.5).timeout
		first_point.try_toggle_next_point_selection()

func get_all_points() -> Array[Node]: return points_container.get_children()

func init_points() -> void:
	var points: Array[Node] = get_all_points()
	for _point: Node in points:
		if _point is EmptyPoint:
			assert(not(_point.end_point and has_end_point), "An End Point Has Already Be Seted Up, Point '%s' Cannot Be An End Point !" % _point.name)
			if _point.end_point and not has_end_point: has_end_point = _point
			_point.try_asign_type()
	
	assert(has_end_point, "No End Point Has Been Found, The Level Is Incomplete !")
