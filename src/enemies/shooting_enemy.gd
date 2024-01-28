extends Enemy

var _Fireball: Resource = load("res://src/enemies/enemy_attack/enemy_bullet.tscn")

@onready var bullets_node: Node = $Bullets
@onready var timer_node: Node = $TimerShots

@export var damage: float = 1

var SPRITE_MAX_NUMBER: int = 8
var areas: Array[CollisionShape2D] = [$enemy_collision, $AttackCollisionComponent/CollisionShape2D, $BodyCollisionComponent/body_collision]

var xp: float = 1

var shoot_direction: Vector2 = Vector2.RIGHT
var player_pos: Vector2 = Vector2.RIGHT

func init(target: Node2D, spawn_position: Vector2, speed: float, hp: float) -> void:
	super(target, spawn_position, speed, hp)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER
	
func _physics_process(_delta) -> void:
	if is_alive:
		_movement_direction = _target.position - position
		_movement_direction = _movement_direction.normalized()
		velocity = ENEMY_DEFAULT_VELOCITY * _movement_direction * 0.5
		move_and_slide()


func _on_health_component_death():
	is_alive = false
	for area in areas:
		area.set_deferred("disabled", true)
	emit_signal("death", xp)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER + SPRITE_MAX_NUMBER
	$AnimationPlayer.play("death")







func shoot():
	var bullet: EnemyBullet = _Fireball.instantiate()

	player_pos = Context.get_player_position()
	shoot_direction = (player_pos - position).normalized()
	
	bullet.init(position, shoot_direction, damage, 200)

	bullets_node.add_child(bullet)


func _on_timer_shots_timeout():
	shoot()
	

