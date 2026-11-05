extends Node3D
class_name DiceRolling

@onready var dice: Dice = %Dice
@onready var camera: Camera3D = %Camera
@onready var initial_dice_position_maker: Marker3D = %InitialDicePositionMaker

var random_number: int = 0
var rolling_dice: bool = false

func _ready() -> void: pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !rolling_dice: print(await roll_dice())

func _process(_delta: float) -> void:
	camera.look_at_from_position(camera.position, dice.position)

func prepare_for_rolling() -> void:
	pass

func roll_dice() -> int:
	rolling_dice = true
	dice.untoggle(true)
	dice.position = initial_dice_position_maker.position
	dice._roll()
	
	await dice.rolled
	rolling_dice = false
	random_number = randi_range(1, 20)
	return random_number
