extends CharacterBody2D
class_name Player

signal death
signal hit
signal choose_augment
signal get_xp(float, int)

@export var PLAYER_DEFAULT_VELOCITY: float = 300.0
var speed: float = PLAYER_DEFAULT_VELOCITY

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var new_fireball: Fireball
@onready var _attacks_node: Node = $Attacks

var xp: float
var level: int = 1
var xp_required: float = 1
const DEFAULT_XP_REQUIRED: float = 1
@onready var MAX_LEVEL: int = Levelling.max_levels_reached()

var direction: Vector2 = Vector2.ZERO

static var _context: Node2D
var is_in_intro = true

const default_stats: Array = [[1., 5., 1], [4., 3., 1], [0.8, 5., 1, 3., PI / 6], [0.4, 40., -1]]
var weapons_enabled: Array[bool] = [true, false, false, false]
@onready var weapons: Array[Node] = $Weapons.get_children()

var augment_chosen: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = PLAYER_DEFAULT_VELOCITY
	$Weapons/Pistol.init(self)
	$Weapons/AssaultRiffle.init(self)
	$Weapons/Shotgun.init(self)
	$Weapons/Sniper.init(self)

# Context should be the map
func init(context: Node2D, spawn_position: Vector2, hp: float):
	_context = context
	position = spawn_position
	
	$SegwaySprite.visible = true
	xp = 0
	xp_required = DEFAULT_XP_REQUIRED
	level = 1
	$HealthComponent.init(hp)
	$HealthBar.init(hp, $HealthComponent)
	
	reset_weapons()

func post_intro():
	is_in_intro = false
	$AnimatedSprite2D.play("default")
	reset_weapons()

func reset_weapons():
	Levelling.reset_levels()
	for i in range(len(weapons)):
		weapons_enabled[i] = false
		weapons[i].update_properties(default_stats[i])
		weapons[i].disable_weapon()
	weapons_enabled[0] = true
	

func start_outro():
	is_in_intro = true
	$BodyCollisionComponent.collision_layer = 0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if is_in_intro:
		return

	set_direction()
	velocity = direction.normalized() * speed

	move_and_slide()


func _process(_delta):
	if is_in_intro:
		return

	if _context && Input.is_action_just_pressed("fireball"):
		var dir: Vector2 = Context.get_nearest_enemy(position)

		new_fireball = _Fireball.instantiate()
		new_fireball.init(position, (dir - position).normalized(), 1, 2 * speed, 1)

		_attacks_node.add_child(new_fireball)

	if Input.is_action_pressed("segway"):
		$SegwaySprite.visible = false
		speed = PLAYER_DEFAULT_VELOCITY * 0.2
		for i in range(len(weapons)):
			if weapons_enabled[i]:
				weapons[i].enable_weapon()
		
	elif $SegwaySprite.visible == false:
		
		$SegwaySprite.visible = true
		speed = PLAYER_DEFAULT_VELOCITY
		for i in range(len(weapons)):
			weapons[i].disable_weapon()


func set_direction() -> void:
	direction = Vector2(Input.is_action_pressed("move_right"), Input.is_action_pressed("move_down")) \
		- Vector2(Input.is_action_pressed("move_left"), Input.is_action_pressed("move_up"))


func print_hp(new_hps) -> void:
	print("hit ! new hp = ", new_hps)


func _on_health_component_death():
	emit_signal("death")


func _on_health_component_health_lost(new_hps: float):
	#print_hp(new_hps)
	emit_signal("hit")


func give_xp(xp_given: float):
	if Context.is_outro():
		return

	xp += xp_given
	emit_signal("get_xp", xp, xp_required, level)
	if (xp >= xp_required) and augment_chosen:
		augment_chosen = false
		level += 1
		xp = xp - xp_required
		xp_required = fibonacci(level)
		level_up()


func level_up():
	#print("level up "+str(level))
	if level > MAX_LEVEL:
		xp_required = 2**30
	else:
		emit_signal("choose_augment")


func connect_player_to_hud(menu: Node, menu_signal: String) -> void:
	menu.connect(menu_signal, aumgent_weapon)


func aumgent_weapon(choice: int) -> void:
	#print("player choice : "+str(choice))
	var weapon = Levelling.choice_to_weapon(choice)
	var new_stats: Array = Levelling.level_up_weapon(weapon)

	if not weapons_enabled[weapon]:
		weapons_enabled[weapon] = true
		$Weapons.get_child(weapon).update_properties(new_stats)

	else:
		$Weapons.get_child(weapon).update_properties(new_stats)

	augment_chosen = true
	emit_signal("get_xp", xp, xp_required, level)

	if (xp >= xp_required):
		print(get_tree().paused)
		print("give xp")
		give_xp(0.)


func fibonacci(n):
	var i: int = 2
	var j: int = 3
	var k: int

	for l in range(n):
		k = j
		j = i + j
		i = k
	return n * 1.5
