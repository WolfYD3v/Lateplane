extends RigidBody3D
class_name Dice

signal rolled

@onready var mesh: MeshInstance3D = %Mesh

@export_range(5.0, 5.01, 0.01, "hide_control", "or_greater") var roll_strength: float = 5.0

var glowing_tween: Tween

func _ready() -> void:
	mesh.material_override = mesh.material_override.duplicate()
	animate_glow(Color(0.0, 0.0, 0.0, 1.0), 0.0)
	untoggle(true)

func _roll():
	untoggle()
	animate_glow(Color(0.0, 0.0, 0.0, 1.0), 0.0)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	transform.basis = Basis(Vector3.RIGHT, randf_range(0.0, 2.5 * PI)) * transform.basis
	transform.basis = Basis(Vector3.UP, randf_range(0.0, 2.5 * PI)) * transform.basis
	transform.basis = Basis(Vector3.FORWARD, randf_range(0.0, 2.5 * PI)) * transform.basis
	
	var throw_vector = Vector3(randf_range(-1.5, 1.5), 0.0, randf_range(-1.5, 1.5)).normalized()
	angular_velocity = throw_vector * roll_strength / randf_range(2.0, 5.0)
	apply_central_impulse(throw_vector * roll_strength)
	animate_glow(Color(1.0, 1.0, 1.0, 1.0), 4.5)
	
	await sleeping_state_changed
	if sleeping: rolled.emit()

func untoggle(value: bool = false) -> void:
	sleeping = value
	freeze = value

func animate_glow(color: Color, duration: float) -> void:
	if glowing_tween: glowing_tween.kill()
	
	if duration <= 0.0: mesh.material_override.emission = color
	else:
		glowing_tween = get_tree().create_tween()
		glowing_tween.tween_property(
			mesh.material_override, "emission",
			color, duration
		)
