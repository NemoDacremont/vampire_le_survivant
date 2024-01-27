extends CharacterBody2D
class_name Enemy

signal death(xp_given: float)
signal hit(dmg: int)


static var _target: Node2D

const ENEMY_DEFAULT_VELOCITY: float = 2 * 48;
var _movement_direction: Vector2
@onready var _sprite: Sprite2D = $Sprite

var is_alive: bool = true

# var _velocity: Vector2


func init(target: Node2D, spawn_position: Vector2, speed: float, hp: float) -> void:
	_target = target
	position = spawn_position
	$HealthComponent.init(hp)


func _physics_process(_delta) -> void:
	if is_alive:
		_movement_direction = _target.position - position
		_movement_direction = _movement_direction.normalized()

		velocity = ENEMY_DEFAULT_VELOCITY * _movement_direction

		move_and_collide(velocity * _delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_health_component_death():
	queue_free()
