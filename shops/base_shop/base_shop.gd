@tool
extends CanvasLayer
class_name BaseShop

signal closed

@onready var transition: ColorRect = %Transition
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var interface: Control = %Interface
@onready var shop_name_label: Label = %ShopNameLabel
@onready var total_amount_label: Label = %TotalAmountLabel
@onready var money_spend_amount_label: Label = %MoneySpendAmountLabel
@onready var shop_items_container: VBoxContainer = %ShopItemsContainer

@export var transition_art: Texture2D = null
@export var shop_name: String = "SHOP NAME":
	set(value):
		if value != "": shop_name = value
		if is_node_ready(): init_shop_name()
@export var skip_transitions: bool = false

var money_spend: int = 0

func _ready() -> void:
	MoneyManager.money_updated.connect(update_total_money)
	
	update_total_money()
	update_money_spend(0)
	
	interface.visible = skip_transitions
	shop_name_label.hide()
	init_shop_name()
	init_transition()
	get_tree().paused = true
	
	if !skip_transitions: try_play_transition("transition_on")

func try_play_transition(trans_name: String) -> void:
	if !animation_player.has_animation(trans_name): return
	
	transition.show()
	shop_name_label.show()
	animation_player.play(trans_name)
	await animation_player.animation_finished
	transition.hide()
	shop_name_label.hide()

func init_shop_name() -> void: shop_name_label.text = shop_name

func init_transition() -> void:
	transition.hide()
	
	if transition_art:
		var shader_material: ShaderMaterial = transition.material.duplicate() as ShaderMaterial
		shader_material.set_shader_parameter("mask_texture", transition_art)
		transition.material = shader_material

func update_total_money() -> void: total_amount_label.text = str(MoneyManager.money)
func update_money_spend(updater: int) -> void:
	money_spend += updater
	money_spend_amount_label.text = str(money_spend)

func close_shop() -> void:
	if !skip_transitions: await try_play_transition("transition_off")
	closed.emit()
	queue_free.call_deferred()
	get_tree().paused = false
