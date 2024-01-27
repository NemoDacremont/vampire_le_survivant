extends Fireball


func _physics_process(delta):
	_velocity = _speed * _direction * 5
	position += delta * _velocity
	_distance += delta * _speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super(_delta)

func _on_collision_component_collision(_node: CollisionComponent):
	pass
