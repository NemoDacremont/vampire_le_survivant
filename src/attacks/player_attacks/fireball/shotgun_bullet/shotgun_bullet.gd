extends Fireball

@onready var sprite_node: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionComponent/CollisionShape2D

func _physics_process(delta):
	_velocity = _speed * _direction * 0.5

	position += delta * _velocity
	_distance += delta * _speed * 3
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super(_delta)

func _on_collision_component_collision(_node: CollisionComponent):
	pass
