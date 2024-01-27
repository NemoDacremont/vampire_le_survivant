extends CharacterBody2D
class_name Player

signal death
signal hit

@export var PLAYER_DEFAULT_VELOCITY: float = 300.0
var speed: float = PLAYER_DEFAULT_VELOCITY

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var new_fireball: Fireball
@onready var _attacks_node: Node = $Attacks

var xp: float
var level: int
var xp_required: float = 1
const MAX_LEVEL: int = 40

var direction: Vector2 = Vector2.ZERO

static var _context: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = PLAYER_DEFAULT_VELOCITY
	$Weapons/AssaultRiffle.init(self)
	$Weapons/Pistol.init(self)
	$Weapons/Sniper.init(self)


# Context should be the map
func init(context: Node2D, spawn_position: Vector2, hp: float):
	_context = context
	position = spawn_position
	xp = 0
	level = 0
	$HealthComponent.init(hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	set_direction()
	velocity = direction.normalized() * speed

	move_and_slide()


func _process(_delta):
	if _context && Input.is_action_just_pressed("fireball"):
		var dir: Vector2 = Context.get_nearest_enemy(position)

		new_fireball = _Fireball.instantiate()
		new_fireball.init(position, (dir - position).normalized(), 2 * speed)

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

func give_xp(xp_given: float):
	xp += xp_given
	while (xp >= xp_required):
		level += 1
		xp = xp - xp_required
		level_up()

func level_up():
	print("level up "+str(level))
	if level > MAX_LEVEL:
		emit_signal("death")
