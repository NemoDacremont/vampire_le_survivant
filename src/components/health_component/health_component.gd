extends Node
class_name HealthComponent

signal health_lost(new_hp: float)
signal death

@export var MAX_HEALTH: float
var _hp: float = MAX_HEALTH


func _ready() -> void:
	#print(_hp)
	pass


func get_hps() -> float:
	return _hp


# Returns hps after applying dmg
func recieve_dmg(dmgs: float) -> float:
	_hp -= dmgs

	if get_hps() <= 0:
		emit_signal("death")
		return 0

	emit_signal("health_lost", get_hps())
	return get_hps()


