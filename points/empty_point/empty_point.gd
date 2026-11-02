extends Node2D
class_name EmptyPoint

@onready var mesh_instance: MeshInstance2D = $MeshInstance

func try_asign_type() -> void:
	if randf_range(0.0, 1.0) > 0.15: pass
