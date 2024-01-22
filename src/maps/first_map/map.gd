extends Node2D

const DEFAULT_SPAWN_RATE: float = 3

@onready var player_scene = load("res://src/player/player.tscn")
@onready var first_enemy = load("res://src/enemies/enemy.tscn")
var enemies: Array
var player: Node2D
var spawn_rate: float
var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	enemies.append(first_enemy)
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func start_game():
	set_up_player()
	set_up_enemies()
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()

func game_over(player: Node2D) -> void:
	player.queue_free()

func set_up_player() -> void:
	player = player_scene.instantiate()
	player.position = Vector2(0, 0)
	self.add_child(player)
	get_node("Camera").track(player)

func set_up_enemies() -> void:
	spawn_rate = DEFAULT_SPAWN_RATE

func spawn_enemy(enemy_scene: Object, spawn_position: Vector2) -> void:
	var enemy = enemy_scene.instantiate()
	enemy.init(player)
	enemy.position = spawn_position
	self.get_node("Enemies").add_child(enemy)

func randomEnemy() -> int:
	return 0

func randomSpawn(origin: Node2D) -> Vector2:
	var length = random.randi_range(50,100)
	var angle = random.randf_range(0, 2*PI)
	return Vector2(cos(angle), sin(angle)) * length

func _on_spawn_enemy_timer_timeout():
	spawn_enemy(enemies[randomEnemy()], randomSpawn(player))
