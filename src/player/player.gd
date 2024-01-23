extends Node2D

signal death
signal hit


@export var PLAYER_DEFAULT_VELOCITY: float = 300.0
var speed: float = PLAYER_DEFAULT_VELOCITY

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var new_fireball: Fireball
@onready var _attacks_node: Node = $Attacks

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = PLAYER_DEFAULT_VELOCITY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_direction()
	velocity = direction.normalized() * speed

	position += velocity * delta


func _process(_delta):
	if Input.is_action_just_pressed("fireball"):
		new_fireball = _Fireball.instantiate()
		new_fireball.init(position, direction.normalized(), 2 * speed)

		_attacks_node.add_child(new_fireball)


func set_direction() -> void:
	direction = Vector2(Input.is_action_pressed("move_right"), Input.is_action_pressed("move_down")) \
		- Vector2(Input.is_action_pressed("move_left"), Input.is_action_pressed("move_up"))


func print_hp(new_hps) -> void:
	print("hit ! new hp = ", new_hps)


func _on_health_component_death():
	emit_signal("death")


func _on_health_component_health_lost(new_hps: float):
	print_hp(new_hps)
	emit_signal("hit")

