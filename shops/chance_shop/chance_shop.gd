@tool
extends BaseShop
class_name ChanceShop

@onready var dice_rolling: DiceRolling = %DiceRolling

var chance: int = 1

func _ready() -> void:
	dice_rolling.hide()
	MoneyManager.money_updated.connect(update_total_money)
	update_total_money()
	if transition_art: background.texture = transition_art
	
	interface.visible = skip_transitions
	shop_name_label.hide()
	init_shop_name()
	init_transition()
	if !skip_transitions:
		try_play_transition("transition_on")
		await animation_player.animation_finished
	
	dice_rolling.show()
	chance = await dice_rolling.roll_dice()
	await get_tree().create_timer(DiceRolling.TIME_TO_READ_NB).timeout
	dice_rolling.hide()
	try_create_shop_items()
	
	get_tree().paused = true

func try_create_shop_items() -> void:
	for loop: int in range(max_item_displayed_count):
		var shop_item_resource: ShopItemResource = all_items.pop_at(
			randi_range(0, all_items.size() - 1)
		)
		var shop_item: BaseShopItem = load(BASE_SHOP_ITEM_PATH).instantiate()
		shop_item.item_texture = shop_item_resource.item_texture
		shop_item.item_name = shop_item_resource.item_name
		shop_item.item_description = shop_item_resource.item_description
		
		if chance == 1: shop_item.item_price = shop_item_resource.item_price
		else:
			var inner_chance: float = randf_range(float(chance), float(chance) * 2.15)
			var pourcentage: float = (inner_chance * 5.0) / 100.0
			print("Chance: %s | Inner Chance: %s | Pourcentage: %s" % [chance, inner_chance, pourcentage])
			var calculated_price: int = shop_item_resource.item_price + roundi(pourcentage * float(shop_item_resource.item_price))
			print("Calculated New Price: %s" % calculated_price)
			shop_item.item_price = calculated_price
		
		shop_items_container.add_child(shop_item)
