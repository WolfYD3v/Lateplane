extends BasePointTypeModifier
class_name ShopPointTypeModifier

const SHOPS_DIRECTORY: String = "res://shops/collection/"

var shops: Array[String] = []
var current_shop: BaseShop = null

func _ready() -> void:
	parent = get_parent()
	parent.sprite.texture = override_texture
	if override_point_name != "": parent.name = override_point_name
	
	act()

func get_shops() -> void:
	for _file: String in DirAccess.get_files_at(SHOPS_DIRECTORY):
		if _file.ends_with(".tscn"): shops.append("%s%s" % [
			SHOPS_DIRECTORY, _file
		])
	print("%s - Shops Found: " % name, shops)

func try_load_random_shop() -> void:
	if shops.is_empty(): return
	
	current_shop = load(shops.pick_random()).instantiate()
	get_tree().root.add_child(current_shop)
	print(current_shop)

func act() -> void:
	if parent:
		get_shops()
		RunManager.player_changed_point.connect(
			func(): if RunManager.current_point == parent:
				print("A Shop Point :)")
				try_load_random_shop()
				await current_shop.closed
				RunManager.trigger_next_point_selection.emit()
		)
