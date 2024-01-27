extends Node2D
class_name Weapon

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var _parent: Node

@export var pos_offset: float
@export var w_idle: float

var _theta: float = 0
var dir: Vector2 = Vector2.RIGHT

@onready var bullets_node: Node = $Bullets
var shoot_direction: Vector2 = Vector2.RIGHT
var nearest_enemy_pos: Vector2 = Vector2.ZERO


# parent_position is a node, the weapon will follow it
func init(parent_position: Node):
	_parent = parent_position


func _physics_process(delta):
	_theta = _theta + w_idle * delta

	dir = Vector2(cos(_theta), sin(_theta)).normalized()

	position = _parent.position + pos_offset * dir


func shoot():
	var bullet: Fireball = _Fireball.instantiate()

	nearest_enemy_pos = Context.get_nearest_enemy(position)
	shoot_direction = (position - nearest_enemy_pos).normalized()

	bullet.init(position, shoot_direction, 500)

	bullets_node.add_child(bullet)


func _on_timer_shots_timeout():
	shoot()

