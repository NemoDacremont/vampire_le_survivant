extends Node2D

signal on_death
signal on_hit

const PLAYER_DEFAULT_VELOCITY: int = 300

var velocity: Vector2
var direction: Vector2
@export var speed: int

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = PLAYER_DEFAULT_VELOCITY

	$HealthComponent.connect("health_lost", print_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_direction()
	velocity = direction.normalized() * speed
	self.position += velocity * delta
	
func set_direction() -> void:
	direction = Vector2(Input.is_action_pressed("move_right"), Input.is_action_pressed("move_down"))\
	- Vector2(Input.is_action_pressed("move_left"), Input.is_action_pressed("move_up"))


func print_hp(new_hps) -> void:
	print("hit ! new hp = ", new_hps)

