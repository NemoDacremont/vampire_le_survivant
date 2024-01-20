extends Node2D

var velocity: Vector2
var direction: Vector2
@export var speed: int

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0, 0)
	direction = Vector2(0, 0)
	speed = 500


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_direction()
	velocity = direction.normalized() * speed
	self.position += velocity * delta
	
func set_direction() -> void:
	direction = Vector2(Input.is_action_pressed("ui_right"), Input.is_action_pressed("ui_down"))\
	- Vector2(Input.is_action_pressed("ui_left"), Input.is_action_pressed("ui_up"))
