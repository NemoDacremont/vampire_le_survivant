extends ShotGun

var enemies: Array[Node]
var enemy: Node2D

func init(parent_position: Node):
	super(parent_position)

	piercing_power = -1
	bullet_number = 5


func _process(_delta):
	pass


func true_shoot(angle : float):
	var bullet: Fireball = _Fireball.instantiate()


	enemies = Context.get_enemies()
	enemy = enemies[randi_range(0, len(enemies) - 1)]

	nearest_enemy_pos = enemy.position

	shoot_direction = (nearest_enemy_pos - position).normalized()
	_wanted_theta = atan2(shoot_direction.y, shoot_direction.x)
	
	var shoot_angle: float = atan2(shoot_direction.y, shoot_direction.x)
	shoot_direction = Vector2(cos(angle + shoot_angle), sin(angle + shoot_angle)).normalized()

	dir = Vector2(cos(_wanted_theta), sin(_wanted_theta)).normalized()
	position = _parent.position - pos_offset * dir
	sprite_node.rotation = _wanted_theta
	print(sprite_node.rotation)


	bullet.init(position, shoot_direction, 150, speed, piercing_power)

	bullets_node.add_child(bullet)
