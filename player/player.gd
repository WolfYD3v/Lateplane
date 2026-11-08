extends StaticBody2D
class_name Player

@onready var head_animated_sprite: AnimatedSprite2D = %HeadAnimatedSprite
@onready var body_animated_sprite: AnimatedSprite2D = %BodyAnimatedSprite
@onready var left_arm_animated_sprite: AnimatedSprite2D = %LeftArmAnimatedSprite
@onready var right_animated_sprite: AnimatedSprite2D = %RightAnimatedSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var moving_tween: Tween = null

func _ready() -> void:
	head_animated_sprite.play("head")
	body_animated_sprite.play("body")
	left_arm_animated_sprite.play("left_arm")
	right_animated_sprite.play("right_arm")
	
	animation_player.speed_scale = 1.0
	animation_player.play("idle")

func move(at_position: Vector2, instant: bool = false) -> void:
	if moving_tween:
		animation_player.speed_scale = 1.0
		moving_tween.kill()
	
	if instant: position = at_position
	else:
		animation_player.speed_scale = 2.5
		moving_tween = get_tree().create_tween()
		moving_tween.tween_property(self, "position", at_position, 1.0)
		moving_tween.finished.connect(func(): animation_player.speed_scale = 1.0)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play(anim_name)
