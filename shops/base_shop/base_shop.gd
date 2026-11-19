@tool
extends CanvasLayer
class_name BaseShop

signal closed

@onready var transition: ColorRect = %Transition
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var interface: Control = %Interface
@onready var shop_name_label: Label = %ShopNameLabel
@onready var total_amount_label: Label = %TotalAmountLabel
@onready var shop_items_container: VBoxContainer = %ShopItemsContainer
@onready var background: TextureRect = %Background
@onready var song_audio_stream_player: AudioStreamPlayer = %SongAudioStreamPlayer

@export var all_items: Array[ShopItemResource] = []
@export_range(1, 2, 1, "or_greater") var max_item_displayed_count: int = 1:
	set(value):
		if value > all_items.size(): max_item_displayed_count = all_items.size()
		else: max_item_displayed_count = value
@export var transition_art: Texture2D = null
@export var shop_name: String = "SHOP NAME":
	set(value):
		if value != "": shop_name = value
		if is_node_ready(): init_shop_name()
@export var skip_transitions: bool = false
@export var song: AudioStream = null

const BASE_SHOP_ITEM_PATH: String = "res://items/shop_items/base_shop_item/base_shop_item.tscn"

func _ready() -> void:
	if song: song_audio_stream_player.stream = song
	MoneyManager.money_updated.connect(update_total_money)
	update_total_money()
	if transition_art: background.texture = transition_art
	
	interface.visible = skip_transitions
	shop_name_label.hide()
	init_shop_name()
	init_transition()
	try_create_shop_items()
	get_tree().paused = true
	
	if !skip_transitions:
		await try_play_transition("transition_on")
		if song: song_audio_stream_player.play()

func try_create_shop_items() -> void:
	for loop: int in range(max_item_displayed_count):
		var shop_item_resource: ShopItemResource = all_items.pop_at(
			randi_range(0, all_items.size() - 1)
		)
		var shop_item: BaseShopItem = load(BASE_SHOP_ITEM_PATH).instantiate()
		shop_item.item_texture = shop_item_resource.item_texture
		shop_item.item_name = shop_item_resource.item_name
		shop_item.item_description = shop_item_resource.item_description
		shop_item.item_price = shop_item_resource.item_price
		shop_items_container.add_child(shop_item)

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

func close_shop() -> void:
	song_audio_stream_player.stop()
	if !skip_transitions: await try_play_transition("transition_off")
	closed.emit()
	queue_free.call_deferred()
	get_tree().paused = false
