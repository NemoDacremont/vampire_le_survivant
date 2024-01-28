extends Weapon


func init(parent_position: Node):
	super(parent_position)
	_Fireball = load("res://src/attacks/player_attacks/fireball/shotgun_bullet/shotgun_bullet.tscn")
	sprite_node = $AnimatedSprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)


func true_shoot(angle : float):
	var bullet: Fireball = _Fireball.instantiate()

	nearest_enemy_pos = Context.get_nearest_enemy(position)
	shoot_direction = (nearest_enemy_pos - position).normalized()
	_wanted_theta = atan2(shoot_direction.y, shoot_direction.x)
	
	var shoot_angle: float = atan2(shoot_direction.y, shoot_direction.x)
	
	shoot_direction = Vector2(cos(angle + shoot_angle), sin(angle + shoot_angle)).normalized()


	bullet.init(position, shoot_direction, damage, 500)

	bullets_node.add_child(bullet)

func _on_timer_shots_timeout():
	if _is_enabled:
		true_shoot(PI / 12)
		true_shoot(-PI / 12)
		true_shoot(2 * PI / 12)
		true_shoot(- 2 * PI / 12)
		true_shoot(0)
		sprite_node.play()
