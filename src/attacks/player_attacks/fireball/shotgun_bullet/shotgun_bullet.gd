extends Fireball

@onready var sprite_node: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionComponent/CollisionShape2D


func _ready():
	var theta : float = atan2(_direction.y, _direction.x)
	sprite_node.rotation = -theta
	collision_shape.rotation = -theta


func init(spawn_position, direction, speed, max_distance = 1000.0):
	super(spawn_position, direction, speed, max_distance)


func _physics_process(delta):
	_velocity = _speed * _direction * 0.5

	position += delta * _velocity
	_distance += delta * _speed * 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super(_delta)

