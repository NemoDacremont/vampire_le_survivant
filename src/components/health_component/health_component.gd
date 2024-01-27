extends Node
class_name HealthComponent

signal health_lost(new_hp: float)
signal death

@export var max_health: float
var _hp: float = max_health

func init(spawn_max_health: float):
	max_health = spawn_max_health
	_hp = spawn_max_health

func heal(heal_amount):
	_hp = max(_hp + heal_amount, max_health)

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


