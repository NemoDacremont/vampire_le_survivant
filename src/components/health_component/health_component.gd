extends Node
class_name HealthComponent

@export var MAX_HEALTH: float = 3.0
var _hp: float = MAX_HEALTH


func _ready() -> void:
	print(_hp)


func get_hps() -> float:
	return _hp


# Returns hps after applying dmg
func deal_dmg(dmgs: float) -> float:
	_hp -= dmgs

	return get_hps()


