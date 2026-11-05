extends RigidBody3D
class_name Dice

signal rolled

@export_range(5.0, 5.01, 0.01, "hide_control", "or_greater") var roll_strength: float = 5.0

func _ready() -> void:
	untoggle(true)

func _roll():
	untoggle()
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	transform.basis = Basis(Vector3.RIGHT, randf_range(0.0, 2.5 * PI)) * transform.basis
	transform.basis = Basis(Vector3.UP, randf_range(0.0, 2.5 * PI)) * transform.basis
	transform.basis = Basis(Vector3.FORWARD, randf_range(0.0, 2.5 * PI)) * transform.basis
	
	var throw_vector = Vector3(randf_range(-1.5, 1.5), 0.0, randf_range(-1.5, 1.5)).normalized()
	angular_velocity = throw_vector * roll_strength / randf_range(2.0, 5.0)
	apply_central_impulse(throw_vector * roll_strength)
	
	await sleeping_state_changed
	if sleeping: rolled.emit()

func untoggle(value: bool = false) -> void:
	sleeping = value
	freeze = value
