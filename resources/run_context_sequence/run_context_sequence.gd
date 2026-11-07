extends Resource
class_name RunContextSequence

@export var image: Texture2D = null
@export var voice_line: AudioStream = null
@export_range(0.5, 0.55, 0.01, "hide_control", "or_greater") var freezing_duration: float = 0.5
