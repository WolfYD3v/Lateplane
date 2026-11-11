@tool
extends Control
class_name BaseShopItem

@onready var item_texture_rect: TextureRect = %ItemTextureRect
@onready var item_name_label: Label = %ItemNameLabel
@onready var item_description_label: Label = %ItemDescriptionLabel
@onready var item_price_label: Label = %ItemPriceLabel
@onready var buy_button: Button = %BuyButton
@onready var disabled_color_rect: ColorRect = %DisabledColorRect

@export var item_texture: Texture2D:
	set(value):
		item_texture = value
		if is_node_ready(): update_item()
@export var item_name: String = "ITEM NAME":
	set(value):
		if value != "": item_name = value
		if is_node_ready(): update_item()
@export var item_description: String = "ITEM DESCRIPTION":
	set(value):
		if value != "": item_description = value
		if is_node_ready(): update_item()
@export_range(1, 2, 1, "or_greater", "hide_control") var item_price: int = 1:
	set(value):
		item_price = value
		if is_node_ready(): update_item()

const BASE_INVENTORY_ITEM_PATH: String = "res://items/inventory_items/base_inventory_item/base_inventory_item.tscn"

var enabled: bool = true
var buyed: bool = false

func _ready() -> void: update_item()

func update_item() -> void:
	item_texture_rect.texture = item_texture
	item_name_label.text = item_name
	item_description_label.text = item_description
	item_price_label.text = "Prix: $%s" % item_price
	update_enable()

func update_enable() -> void:
	enabled = item_price <= MoneyManager.money and !buyed
	buy_button.disabled = !enabled
	disabled_color_rect.visible = !enabled

func _on_buy_button_pressed() -> void:
	if !InventoryManager.can_store_more():
		print("Cannot Buy It: No More Space In The Inventory")
		return
	if !MoneyManager.try_buy(item_price):
		print("Cannot Buy It: Too Expensive For The Money Amount You Currently Have")
		return
	
	var packed_scene: PackedScene = load(BASE_INVENTORY_ITEM_PATH)
	var inventory_item: BaseInventoryItem = packed_scene.instantiate()
	inventory_item.item_name = item_name
	inventory_item.item_texture = item_texture
	InventoryManager.try_add_item(inventory_item)
	buyed = true
	update_enable()
