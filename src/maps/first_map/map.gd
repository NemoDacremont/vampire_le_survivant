extends Node2D

const DEFAULT_SPAWN_RATE: float = .2
const DEFAULT_MAX_HP_PLAYER: float = 5

@onready var _Enemy = load("res://src/enemies/enemy.tscn")
@onready var _Little_Enemy = load("res://src/enemies/little_enemy.tscn")
@onready var _Fast_Enemy = load("res://src/enemies/fast_enemy.tscn")
@onready var _Shooting_Enemy = load("res://src/enemies/shooting_enemy.tscn")
@onready var _Mini_Enemy = load("res://src/enemies/mini_enemy.tscn")


@onready var _Enemies: Array[Resource] = [
	_Little_Enemy,
	_Fast_Enemy,
	_Shooting_Enemy,
	_Mini_Enemy
]

var _player: Player
var spawn_rate: float = 1
var random: RandomNumberGenerator = RandomNumberGenerator.new()

var is_intro_over = false


func _ready() -> void:
	Context.set_context(self)
	
	_player = $Player
	_player.death.connect(start_game)
	$LevelUpMenu.connect_hud_to_player(_player, "choose_augment")
	_player.connect_player_to_hud($LevelUpMenu, "augment_chosen")

	start_intro()


func start_intro():
	print("START INTRO")
	set_up_player()
	$Camera.zoom = Vector2(3.0, 3.0)
	$Background.call_deferred("init", get_player_position())
	$Camera.track($Intro/CameraPosition)
	# $Camera.

	var enemy = $Intro/Enemy
	enemy.init($Intro/EnemyTarget, $Intro/EnemySpawn.position, 0, 1)
	enemy.death.connect(end_intro)

	

func end_intro(_no_xp):
	# show_hud()
	# $Camera.zoom = Vector2(1.5, 1.5)
	$Camera.track(_player)
	create_tween().tween_property($Camera, "zoom", Vector2(1.5, 1.5), 0.5).set_ease(Tween.EASE_IN)

	print("END INTRO!")
	$TimerHUD.init()
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()


func start_game() -> void:
	set_up_player()
	set_up_enemies()
	$TimerHUD.init()
	$Background.call_deferred("init", get_player_position())
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()


func game_over(player: Node2D) -> void:
	player.queue_free()


func set_up_player() -> void:
	_player.init(self, Vector2.ZERO, DEFAULT_MAX_HP_PLAYER)
	$Camera.track(_player)


func set_up_enemies() -> void:
	for enemy in $Enemies.get_children():
		enemy.queue_free()
	spawn_rate = DEFAULT_SPAWN_RATE


func spawn_enemy(EnemyClass: Resource, spawn_position: Vector2) -> void:
	var enemy = EnemyClass.instantiate()
	enemy.init(_player, spawn_position, 0, 3)
	enemy.position = spawn_position
	enemy.death.connect(_player.give_xp)

	$Enemies.add_child(enemy)


func randomEnemy() -> int:
	return random.randi_range(0, len(_Enemies) - 1)


func get_nearest_enemy(pos: Vector2) -> Vector2:
	var enemies = $Enemies.get_children()

	if len(enemies) == 0:
		return Vector2.ZERO

	var nearest = enemies[0]
	var min_dist: float = pos.distance_to(nearest.position)
	var dist: float

	for enemy in enemies:
		dist = pos.distance_to(enemy.position)

		if (dist < min_dist):
			nearest = enemy
			min_dist = dist

	return nearest.position


func randomSpawn(origin: Vector2) -> Vector2:
	var length = random.randi_range(500, 600)
	var angle = random.randf_range(0, 2*PI)

	return origin + Vector2(cos(angle), sin(angle)) * length


func get_player_position() -> Vector2:
	return _player.position


func _on_spawn_enemy_timer_timeout():
	spawn_enemy(_Enemies[randomEnemy()], randomSpawn(_player.position))
