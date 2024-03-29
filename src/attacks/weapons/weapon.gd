extends Node2D
class_name Weapon

enum {FIRE_RATE=0, DAMAGE, PIERCING, NUMBER, SPRAY}

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var _parent: Node

@export var pos_offset: float
@export var w_idle: float
var w: float
var K: float = 10

var _theta: float = 0
var _wanted_theta: float = 0
var dir: Vector2 = Vector2.RIGHT

var _is_enabled: bool = false

@onready var bullets_node: Node = $Bullets
@onready var sprite_node: Node2D = $Sprite
@onready var timer_node: Node = $TimerShots
@onready var preshot_timer: Timer = $Preshot

var shoot_direction: Vector2 = Vector2.RIGHT
var nearest_enemy_pos: Vector2 = Vector2.ZERO

@export var damage: float = 1
var piercing_power: float = 1

# parent_position is a node, the weapon will follow it
func init(parent_position: Node):
	_parent = parent_position
	sprite_node.visible = false
	


func _process(delta):
	_wanted_theta += w_idle * delta
	
	w = w_idle * (_wanted_theta - _theta) * K

	_theta = _theta + w * delta

	dir = Vector2(cos(_theta), sin(_theta)).normalized()

	position = _parent.position + pos_offset * dir
	sprite_node.rotation = _theta


func force_shoot(direction: Vector2):
	var bullet: Fireball = _Fireball.instantiate()
	visible = true

	shoot_direction = direction
	_wanted_theta = atan2(shoot_direction.y, shoot_direction.x)

	preshot_timer.start()
	await preshot_timer.timeout

	bullet.init(position, shoot_direction, damage, 500, piercing_power)
	bullets_node.add_child(bullet)


func shoot():
	var bullet: Fireball = _Fireball.instantiate()

	if $AudioStreamPlayer.stream:
		$AudioStreamPlayer.play()

	nearest_enemy_pos = Context.get_nearest_enemy(position)
	shoot_direction = (nearest_enemy_pos - position).normalized()

	_wanted_theta = atan2(shoot_direction.y, shoot_direction.x)

	preshot_timer.start()
	await preshot_timer.timeout
	
	#nearest_enemy_pos = Context.get_nearest_enemy(position)
	shoot_direction = (nearest_enemy_pos - position).normalized()
	bullet.init(position, shoot_direction, damage, 500, piercing_power)
	bullets_node.add_child(bullet)


func _on_timer_shots_timeout():
	if _is_enabled:
		shoot()
	
func enable_weapon():
	sprite_node.visible = true
	_is_enabled = true
	
func disable_weapon():
	sprite_node.visible = false
	_is_enabled = false


func update_properties(stats: Array) -> void:
	timer_node.wait_time = 1 / stats[FIRE_RATE]
	damage = stats[DAMAGE]
	piercing_power = stats[PIERCING]
	
