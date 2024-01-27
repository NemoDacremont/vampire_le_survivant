extends Node2D

const DEFAULT_SPAWN_RATE: float = .2

@onready var _Player = load("res://src/player/player.tscn")
@onready var _Enemy = load("res://src/enemies/enemy.tscn")

var _Enemies: Array[Resource]
var _player: Node2D
var spawn_rate: float
var random: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	Context.set_context(self)

	$Background.init(Vector2.ZERO)
	_Enemies.append(_Enemy)
	
	_player = _Player.instantiate()
	add_child(_player)
	_player.connect("death", start_game)
	start_game()


func start_game() -> void:
	set_up_player()
	set_up_enemies()
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()


func game_over(player: Node2D) -> void:
	player.queue_free()


func set_up_player() -> void:
	_player.init(self, Vector2.ZERO)
	$Camera.track(_player)


func set_up_enemies() -> void:
	for enemy in $Enemies.get_children():
		enemy.queue_free()
	spawn_rate = DEFAULT_SPAWN_RATE


func spawn_enemy(EnemyClass: Resource, spawn_position: Vector2) -> void:
	var enemy = EnemyClass.instantiate()
	enemy.init(_player)
	enemy.position = spawn_position

	$Enemies.add_child(enemy)



func randomEnemy() -> int:
	return 0


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


