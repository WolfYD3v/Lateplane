extends Resource
class_name ShopItemResource

@export var item_texture: Texture2D
@export var item_name: String = "ITEM NAME"
@export var item_description: String = "ITEM DESCRIPTION"
@export_range(1, 2, 1, "or_greater", "hide_control") var item_price: int = 1
