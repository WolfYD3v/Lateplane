extends Node2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
	play_animation("idle")

func play_animation(animation_name: String) -> void:
	animated_sprite.play(animation_name)
