extends Node2D

const DEFAULT_SPAWN_RATE: float = 3

@onready var player_scene = load("res://src/player/player.tscn")
@onready var first_enemy = load("res://src/enemies/enemy.tscn")
var enemies: Array
var player: Node2D
var spawn_timer: float
var spawn_rate: float

func _ready():
	start_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer += delta
	
	if spawn_timer > spawn_rate:
		spawn_enemy(first_enemy, Vector2(0, 0))
		spawn_timer = 0
	

func start_game():
	set_up_player()
	set_up_enemies()

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
