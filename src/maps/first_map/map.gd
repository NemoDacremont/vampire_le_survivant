extends Node2D

const DEFAULT_SPAWN_RATE: float = 3

@onready var _Player = load("res://src/player/player.tscn")
@onready var _Enemy = load("res://src/enemies/enemy.tscn")

var _enemies: Array[Enemy]
var _Enemies: Array[Resource]
var _player: Node2D
var spawn_rate: float
var random: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_Enemies.append(_Enemy)
	start_game()


func start_game() -> void:
	set_up_player()
	set_up_enemies()
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()


func game_over(player: Node2D) -> void:
	player.queue_free()


func set_up_player() -> void:
	_player = _Player.instantiate()
	_player.position = Vector2(0, 0)
	add_child(_player)

	$Camera.track(_player)


func set_up_enemies() -> void:
	spawn_rate = DEFAULT_SPAWN_RATE


func spawn_enemy(EnemyClass: Resource, spawn_position: Vector2) -> void:
	var enemy = EnemyClass.instantiate()
	enemy.init(_player)
	enemy.position = spawn_position
	_Enemies.append(enemy)
	$Enemies.add_child(enemy)

	self.get_node("Enemies").add_child(enemy)

func randomEnemy() -> int:
	return 0

func randomSpawn(origin: Node2D) -> Vector2:
	var length = random.randi_range(50,100)
	var angle = random.randf_range(0, 2*PI)
	return Vector2(cos(angle), sin(angle)) * length

func _on_spawn_enemy_timer_timeout():
	spawn_enemy(_Enemies[randomEnemy()], randomSpawn(_player))
