extends ProgressBar

var max_health_bar_value: float
var health_value: float

@export var offset_display: Vector2
	
func init(max_player_health: float, healthComponent: Node) -> void:
	position.y = offset_display.y
	healthComponent.death.connect(disappear)
	healthComponent.health_lost.connect(set_hp_bar)
	max_health_bar_value = max_player_health
	health_value = max_player_health
	refresh_health_bar()
	size = Vector2(56, 5)

func disappear():
	visible = false
	
func set_hp_bar(hp: float):
	size = Vector2(56, 5)
	health_value = hp
	refresh_health_bar()
	
func refresh_health_bar():
	if health_value == max_health_bar_value || health_value == 0:
		visible = false
	else:
		visible = true
		value = (health_value / max_health_bar_value) * 100

