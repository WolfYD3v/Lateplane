extends Control
class_name PlayerGUI

@onready var money_amount_label: Label = %MoneyAmountLabel
@onready var days_left_count_label: Label = %DaysLeftCountLabel
@onready var inventory: Control = %Inventory
@onready var inventory_grid_container: GridContainer = %InventoryGridContainer

func _ready() -> void:
	MoneyManager.money_updated.connect(update_money_label)
	RunManager.days_count_updated.connect(update_days_left_label)
	InventoryManager.items_updated.connect(update_inventory)
	update_money_label()
	update_days_left_label()
	update_inventory()
	toggle_inventory(false)

func update_money_label() -> void: money_amount_label.text = str(MoneyManager.money)
func update_days_left_label() -> void: days_left_count_label.text = str(RunManager.days_count)

func toggle_inventory(value: bool = true) -> void: inventory.visible = value
func update_inventory() -> void:
	for _old_item: Control in inventory_grid_container.get_children(): _old_item.queue_free()
	for _new_item: BaseInventoryItem in InventoryManager.items:
		var item: BaseInventoryItem = _new_item.duplicate()
		item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item.size_flags_vertical = Control.SIZE_EXPAND_FILL
		item.name = "BaseInventoryItem"
		inventory_grid_container.add_child(item)

func _on_open_inventory_button_pressed() -> void:
	update_inventory()
	toggle_inventory()

func _on_close_inventory_button_pressed() -> void: toggle_inventory(false)
