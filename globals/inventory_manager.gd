extends Node

signal items_updated

var items: Array[BaseInventoryItem] = []

const MAX_ITEMS_COUNT: int = 16

func clear_items() -> void: items.clear()

func try_add_item(item: BaseInventoryItem) -> bool:
	if items.size() + 1 > MAX_ITEMS_COUNT: return false
	if has_item(item): return false
	
	items.append(item)
	_trigger_update_signal()
	return true

func try_remove_item(item: BaseInventoryItem) -> bool:
	if items.size() - 1 < 0: return false
	
	var idx: int = item.get_parent().get_children().find(item)
	items.remove_at(idx)
	_trigger_update_signal()
	return true

func has_item(item: BaseInventoryItem) -> bool: return items.has(item)

func _trigger_update_signal() -> void: items_updated.emit()
# print("Inventory Manager - Inventory State: ", items)
