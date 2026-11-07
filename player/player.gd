extends StaticBody2D
class_name Player

@onready var head_animated_sprite: AnimatedSprite2D = %HeadAnimatedSprite
@onready var body_animated_sprite: AnimatedSprite2D = %BodyAnimatedSprite
@onready var left_arm_animated_sprite: AnimatedSprite2D = %LeftArmAnimatedSprite
@onready var right_animated_sprite: AnimatedSprite2D = %RightAnimatedSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	head_animated_sprite.play("head")
	body_animated_sprite.play("body")
	left_arm_animated_sprite.play("left_arm")
	right_animated_sprite.play("right_arm")
	
	animation_player.play("idle")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play(anim_name)
