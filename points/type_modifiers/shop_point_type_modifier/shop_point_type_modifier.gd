extends BasePointTypeModifier
class_name ShopPointTypeModifier

var current_shop: BaseShop = null

func _ready() -> void:
	print("rrrrrrr ", RunManager.shops.size() > RunManager.shops_placed_count)
	if RunManager.shops.size() > RunManager.shops_placed_count:
		RunManager.shops_placed_count += 1
		parent = get_parent()
		parent.sprite.texture = override_texture
		if override_point_name != "": parent.name = override_point_name
		if override_point_description != "": parent.description = override_point_description
		parent.update_name_label_text()
		
		act()
	
	else: queue_free.call_deferred()

func try_load_random_shop() -> void:
	if RunManager.shops.is_empty(): return
	
	current_shop = load(RunManager.shops.pop_at(
		randi_range(0, RunManager.shops.size() - 1)
	)).instantiate()
	get_tree().root.add_child(current_shop)
	print(current_shop)

func act() -> void:
	if parent:
		RunManager.player_changed_point.connect(
			func(): if RunManager.current_point == parent:
				print("A Shop Point :)")
				try_load_random_shop()
				await current_shop.closed
				RunManager.trigger_next_point_selection.emit()
		)
