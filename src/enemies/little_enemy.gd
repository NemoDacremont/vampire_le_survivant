extends Enemy

var SPRITE_MAX_NUMBER: int = 8
var areas: Array[CollisionShape2D] = [$enemy_collision, $AttackCollisionComponent/CollisionShape2D, $BodyCollisionComponent/body_collision]

func init(target: Node2D) -> void:
	super(target)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER

func _on_health_component_death():
	is_alive = false
	for area in areas:
		area.set_deferred("disabled", true)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER + SPRITE_MAX_NUMBER
	$AnimationPlayer.play("death")
