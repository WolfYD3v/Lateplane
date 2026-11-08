extends Resource
class_name RandomEventAction

enum Actions {
	GAME_OVER
}

@export_range(1, 20, 1) var chance_value: int
@export var action: Actions

func execute_action() -> void:
	match action:
		Actions.GAME_OVER: print("Run Lost")
		_: print("f")
