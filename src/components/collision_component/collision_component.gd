extends Area2D
class_name CollisionComponent

signal collision(node: CollisionComponent)


@export var health_component: HealthComponent


func get_health_component() -> Variant:
	if health_component:
		return health_component

	return null


func _on_area_entered(area: Area2D):
	if area is CollisionComponent:
		emit_signal("collision", area)

