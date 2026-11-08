extends TextureRect
class_name DiceRolling

signal click_done

@onready var dice: Dice = %Dice
@onready var camera: Camera3D = %Camera
@onready var initial_dice_position_maker: Marker3D = %InitialDicePositionMaker
@onready var sub_viewport: SubViewport = %SubViewport
@onready var timer: Timer = %Timer
@onready var click_instruction: Control = %ClickInstruction

var random_number: int = 0
var rolling_dice: bool = false

func _ready() -> void: click_instruction.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !rolling_dice: click_done.emit()

func _process(_delta: float) -> void:
	camera.look_at_from_position(camera.position, dice.position)

func prepare_for_rolling() -> void:
	pass

func roll_dice() -> int:
	click_instruction.show()
	await click_done
	click_instruction.hide()
	
	rolling_dice = true
	dice.untoggle(true)
	dice.position = initial_dice_position_maker.position
	dice._roll()
	timer.start()
	
	await dice.rolled
	timer.stop()
	rolling_dice = false
	random_number = randi_range(1, 20)
	return random_number

func _on_timer_timeout() -> void:
	print("Timer: timeed out !")
	dice.rolled.emit()
