extends EnemyBullet
class_name BossBullet


@onready var sprite_node: Sprite2D = $Sprite
var _angle: float

func _ready():
	sprite_node.rotation = _angle

func init(spawn_position: Vector2, direction: Vector2, damage: float, speed: float, max_distance: float = 1000.0) -> void:
	_direction = direction

	_angle = atan2(direction.y, direction.x)

	_speed = speed
	position = spawn_position
	_max_distance = max_distance
	$AttackComponent.set_damage(damage)


