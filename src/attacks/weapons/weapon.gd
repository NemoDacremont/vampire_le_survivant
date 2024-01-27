extends Node2D
class_name Weapon

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var _parent: Node

@export var pos_offset: float
@export var w_idle: float
var w: float
var K: float = 10

var _theta: float = 0
var _wanted_theta: float = 0
var dir: Vector2 = Vector2.RIGHT

@onready var bullets_node: Node = $Bullets
@onready var sprite_node: Sprite2D = $Sprite

var shoot_direction: Vector2 = Vector2.RIGHT
var nearest_enemy_pos: Vector2 = Vector2.ZERO


# parent_position is a node, the weapon will follow it
func init(parent_position: Node):
	_parent = parent_position


func _process(delta):
	_wanted_theta += w_idle * delta
	
	w = w_idle * (_wanted_theta - _theta) * K

	_theta = _theta + w * delta

	dir = Vector2(cos(_theta), sin(_theta)).normalized()
	#print(_theta)

	position = _parent.position + pos_offset * dir
	sprite_node.rotation = _theta


func shoot():
	var bullet: Fireball = _Fireball.instantiate()

	nearest_enemy_pos = Context.get_nearest_enemy(position)
	shoot_direction = (nearest_enemy_pos - position).normalized()

	_wanted_theta = atan2(shoot_direction.y, shoot_direction.x)
	#print(_wanted_theta)
	#print(_wanted_theta)
	#print(_wanted_theta)

	bullet.init(position, shoot_direction, 500)

	bullets_node.add_child(bullet)


func _on_timer_shots_timeout():
	shoot()

