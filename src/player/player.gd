extends CharacterBody2D
class_name Player

signal death
signal hit
signal choose_augment

@export var PLAYER_DEFAULT_VELOCITY: float = 300.0
var speed: float = PLAYER_DEFAULT_VELOCITY

var _Fireball: Resource = load("res://src/attacks/player_attacks/fireball/fireball.tscn")
var new_fireball: Fireball
@onready var _attacks_node: Node = $Attacks

var xp: float
var level: int = 1
var xp_required: float = 1
@onready var MAX_LEVEL: int = Levelling.max_levels_reached()

var direction: Vector2 = Vector2.ZERO

static var _context: Node2D

var weapons_enabled: Array[bool] = [true, false, false, false]

@onready var weapons: Array[Node] = $Weapons.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = PLAYER_DEFAULT_VELOCITY
	$Weapons/AssaultRiffle.init(self)
	$Weapons/Pistol.init(self)
	$Weapons/Sniper.init(self)
	$Weapons/Shotgun.init(self)
	
	print(weapons)

# Context should be the map
func init(context: Node2D, spawn_position: Vector2, hp: float):
	_context = context
	position = spawn_position
	
	$SegwaySprite.visible = true
	xp = 0
	level = 0
	$HealthComponent.init(hp)
	$HealthBar.init(hp, $HealthComponent)
	
	for weapon in $Weapons.get_children():
		weapon.disable_weapon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	set_direction()
	velocity = direction.normalized() * speed

	move_and_slide()


func _process(_delta):
	if _context && Input.is_action_just_pressed("fireball"):
		var dir: Vector2 = Context.get_nearest_enemy(position)

		new_fireball = _Fireball.instantiate()
		new_fireball.init(position, (dir - position).normalized(), 1, 2 * speed)

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
		xp_required = 2**30
	else:
		emit_signal("choose_augment")

func connect_player_to_hud(menu: Node, menu_signal: String) -> void:
	menu.connect(menu_signal, aumgent_weapon)

func aumgent_weapon(choice: int) -> void:
	print("player choice : "+str(choice))
	var weapon = Levelling.choice_to_weapon(choice)
	var new_stats: Array = Levelling.level_up_weapon(weapon)
	if new_stats[-1] == 0:
		print("weapon enabled : "+str(weapon))
		weapons_enabled[weapon] = true
		new_stats.erase(0)
		$Weapons.get_child(weapon).update_properties(new_stats)
	else:
		$Weapons.get_child(weapon).update_properties(new_stats)
