extends Enemy


var SPRITE_MAX_NUMBER: int = 8
var areas: Array[CollisionShape2D] = [$enemy_collision, $AttackCollisionComponent/CollisionShape2D, $BodyCollisionComponent/body_collision]

var xp: float = 1


func init(target: Node2D, spawn_position: Vector2, speed: float, hp: float) -> void:
	super(target, spawn_position, speed, hp)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER

func _physics_process(_delta) -> void:
	if is_alive:
		_movement_direction = _target.position - position
		_movement_direction = _movement_direction.normalized()

		velocity = ENEMY_DEFAULT_VELOCITY * _movement_direction * 2

		move_and_slide()

func _on_health_component_death():
	is_alive = false
	for area in areas:
		area.set_deferred("disabled", true)
	emit_signal("death", xp)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER + SPRITE_MAX_NUMBER
	$AnimationPlayer.play("death")
