extends PlayerAttack
class_name Fireball

var _max_distance: float = 1000.0
var _distance: float = 0.0

var _velocity: Vector2

var _direction: Vector2
var _speed: float


func init(spawn_position: Vector2, direction: Vector2, damage: float, speed: float, max_distance: float = 1000.0) -> void:
	_direction = direction
	_speed = speed
	position = spawn_position
	_max_distance = max_distance
	$AttackComponent.set_damage(damage)


func _physics_process(delta):
	_velocity = _speed * _direction

	position += delta * _velocity
	_distance += delta * _speed


func _process(_delta):
	if _max_distance <= _distance:
		queue_free()

	

func _on_collision_component_collision(_node: CollisionComponent):
	queue_free()

