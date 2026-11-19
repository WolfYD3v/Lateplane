extends BaseLevel
class_name TutorialLevel

@onready var black_outline: ColorRect = %BlackOutline
@onready var cards_container: Control = %CardsContainer
@onready var previous_card_button: Button = %PreviousCardButton
@onready var next_card_button: Button = %NextCardButton
@onready var tutorial_section: Control = %TutorialSection

var current_tutorial_card: TutorialCard = null
var current_tutorial_card_idx: int = 0

func _ready() -> void:
	RunManager.get_shops()
	update_switch_card_btns()
	init_tutorial_cards()
	super()

func _process(delta: float) -> void:
	if black_outline: black_outline.rotation_degrees += (5.0 * delta)

func init_tutorial_cards() -> void:
	for _tutorial_card: TutorialCard in cards_container.get_children():
		_tutorial_card.hide()
	change_tutorial_card()

func change_tutorial_card() -> void:
	if current_tutorial_card: current_tutorial_card.hide()
	current_tutorial_card = cards_container.get_child(current_tutorial_card_idx)
	current_tutorial_card.show()

func update_switch_card_btns() -> void:
	previous_card_button.disabled = current_tutorial_card_idx <= 0
	if current_tutorial_card_idx >= cards_container.get_child_count() - 1: next_card_button.text = "Jouer >>>"
	else: next_card_button.text = "Suivant >>>"

func _on_previous_card_button_pressed() -> void:
	if current_tutorial_card_idx - 1 >= 0:
		current_tutorial_card_idx -= 1
		change_tutorial_card()
		update_switch_card_btns()

func _on_next_card_button_pressed() -> void:
	if current_tutorial_card_idx + 1 <= cards_container.get_child_count() - 1:
		current_tutorial_card_idx += 1
		change_tutorial_card()
		update_switch_card_btns()
	else: tutorial_section.queue_free.call_deferred()
