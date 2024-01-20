extends Node2D

@onready var player_scene = load("res://src/player/player.tscn")
var player: Node2D
var spawn_timer: float
var spawn_rate: float

func _ready():
	start_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer += delta
	

func start_game():
	set_up_player()
	set_up_ennemies()

func game_over(player: Node2D) -> void:
	player.queue_free()

func set_up_player() -> void:
	player = player_scene.instantiate()
	player.position = Vector2(0, 0)
	self.add_child(player)
	get_node("Camera").track(player)

func set_up_ennemies() -> void:
	spawn_rate = 3
