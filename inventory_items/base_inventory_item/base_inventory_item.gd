@tool
extends Control
class_name BaseInventoryItem

signal acted

@onready var item_texture_rect: TextureRect = %ItemTextureRect
@onready var item_name_label: Label = %ItemNameLabel

@export var item_texture: Texture2D:
	set(value):
		item_texture = value
		if is_node_ready(): update_item()
@export var item_name: String = "ITEM NAME":
	set(value):
		if value != "": item_name = value
		if is_node_ready(): update_item()

func _ready() -> void: update_item()

func update_item() -> void:
	item_texture_rect.texture = item_texture
	item_name_label.text = item_name

func act() -> void:
	print("TODO: Make the item do something now bozo")
	acted.emit()

func _on_use_button_pressed() -> void:
	print(InventoryManager.try_remove_item(self))
	act()
	await acted
	queue_free()
