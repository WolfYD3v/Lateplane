extends AudioStreamPlayer
class_name ButtonSFXPlayer

func _ready() -> void:
	var parent: Node = get_parent()
	if parent and parent is Button: parent.pressed.connect(_play)

func _play() -> void: play()
