extends StaticBody3D
class_name DiceJar

@onready var spiner_csg_combiner: CSGCombiner3D = %SpinerCSGCombiner
@onready var spiner_collision: CollisionShape3D = %SpinerCollision

@export_range(0.05, 0.5, 0.01) var spiner_rotation_speed: float = 0.25
@export var allow_spiner_rotation: bool = true

func _process(delta: float) -> void:
	if allow_spiner_rotation:
		spiner_csg_combiner.rotate_y(spiner_rotation_speed * delta)
		spiner_collision.rotate_y(spiner_rotation_speed * delta)
