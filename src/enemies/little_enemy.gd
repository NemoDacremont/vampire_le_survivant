extends Enemy

var SPRITE_MAX_NUMBER: int = 8
var areas: Array[CollisionShape2D] = [$enemy_collision, $AttackCollisionComponent/CollisionShape2D, $BodyCollisionComponent/body_collision]



func init(target: Node2D, spawn_position: Vector2, speed: float, hp: float, _xp: float = 1) -> void:
	super(target, spawn_position, speed, hp, _xp)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER

func _on_health_component_death():
	is_alive = false

	for area in areas:
		area.set_deferred("disabled", true)

	emit_signal("death", xp)

	$Sprite.frame = randi() % SPRITE_MAX_NUMBER + SPRITE_MAX_NUMBER
	$AnimationPlayer.play("death")


func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "death":
		queue_free()

