extends Node2D

signal death
signal hit(dmg: int)


static var _target: Node2D

const ENEMY_DEFAULT_VELOCITY: float = 2 * 48;
var _movement_direction: Vector2
var _velocity: Vector2


func init(target: Node2D) -> void:
	_target = target


func _physics_process(delta) -> void:
	_movement_direction = _target.position - position
	_movement_direction = _movement_direction.normalized()

	_velocity = ENEMY_DEFAULT_VELOCITY * _movement_direction

	position += _velocity * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

