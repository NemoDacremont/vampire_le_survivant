extends Node2D
class_name Arme

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
@onready var bullets_node: Node = $Bullets

func shot():
	var bullet: Fireball = _Fireball.instantiate()
	bullet.init(position, Vector2.RIGHT, 500)

	bullets_node.add_child(bullet)




func _on_timer_shots_timeout():
	shot()

