extends Node

signal money_updated

var money: int = 0:
	set(value):
		money = value
		money_updated.emit()

func try_buy(cost: int) -> bool:
	var can_buy: bool = money - cost >= 0
	if can_buy: use_money(cost)
	
	return can_buy

func add_money(amount: int) -> void: money += amount
func use_money(amount: int) -> void: money -= amount
