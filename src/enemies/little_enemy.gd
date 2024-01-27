extends Enemy

var SPRITE_MAX_NUMBER: int = 8

func init(target: Node2D) -> void:
	super(target)
	$Sprite.frame = randi() % SPRITE_MAX_NUMBER

func _on_health_component_death():
	queue_free()