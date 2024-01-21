extends Node
class_name attack_component

signal hit(node: Node2D)


@export var hitbox: Area2D
@export var dmg: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if hitbox:
		hitbox.connect("body_entered", _process_collision)


func _process_collision(node: Node2D):
	if node.health_component:
		(node.health_component as HealthComponent).deal_dmg(dmg)
		emit_signal("hit", node)

