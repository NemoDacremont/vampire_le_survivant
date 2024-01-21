extends Node
class_name attack_component

signal hit(node: Node)

@export var hitbox: CollisionComponent
@export var dmg: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if hitbox:
		hitbox.connect("collision", _process_collision)


func _process_collision(node: CollisionComponent):
	if node.health_component:
		node.health_component.recieve_dmg(dmg)
		emit_signal("hit", node.owner)

