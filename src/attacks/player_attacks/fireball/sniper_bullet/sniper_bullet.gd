extends Fireball

@onready var sprite_node: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionComponent/CollisionShape2D

func _ready():
	var theta : float = atan2(_direction.y, _direction.x)
	sprite_node.rotation = theta + PI / 2
	collision_shape.rotation = theta + PI / 2


func _physics_process(delta):
	_velocity = _speed * _direction * 5
	position += delta * _velocity
	_distance += delta * _speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super(_delta)

# Inifinite piercing
func _on_collision_component_collision(_node: CollisionComponent):
	pass
