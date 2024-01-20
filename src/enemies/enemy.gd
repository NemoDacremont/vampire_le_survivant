extends Node2D

signal on_death
signal on_hit(dmg: int)



static var _target: Node2D

const ENEMY_DEFAULT_VELOCITY: float = 2 * 48;
static var _movement_direction: Vector2
static var _velocity: Vector2

const ENEMY_DEFAULT_MAX_HP = 3
static var _current_hp = ENEMY_DEFAULT_MAX_HP


func init(target: Node2D) -> void:
	_target = target
	_current_hp = ENEMY_DEFAULT_MAX_HP


func _physics_process(delta) -> void:
	_movement_direction = _target.position - position
	_movement_direction = _movement_direction.normalized()

	_velocity = ENEMY_DEFAULT_VELOCITY * _movement_direction

	position += _velocity * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_attack_hitbox_area_entered(_area: Area2D):
	_current_hp -= 1;

	emit_signal("on_hit", 1)

	if (_current_hp <= 0):
		emit_signal("on_death")

