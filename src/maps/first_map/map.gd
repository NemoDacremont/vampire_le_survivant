extends Node2D

const DEFAULT_SPAWN_RATE: float = 3

@onready var _Player = load("res://src/player/player.tscn")
@onready var _Enemy = load("res://src/enemies/enemy.tscn")

var _enemies: Array[Enemy]
var _player: Node2D
var spawn_timer: float
var spawn_rate: float


func _ready() -> void:
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	spawn_timer += delta

	if spawn_timer > spawn_rate:
		spawn_enemy(_Enemy, Vector2.ZERO)
		spawn_timer = 0


func start_game() -> void:
	set_up_player()
	set_up_enemies()


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

	_enemies.append(enemy)
	$Enemies.add_child(enemy)

