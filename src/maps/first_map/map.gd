extends Node2D

const DEFAULT_SPAWN_RATE: float = 1
const DEFAULT_MAX_HP_PLAYER: float = 500

@onready var _Enemy = load("res://src/enemies/enemy.tscn")
@onready var _Little_Enemy = load("res://src/enemies/little_enemy.tscn")
@onready var _Fast_Enemy = load("res://src/enemies/fast_enemy.tscn")
@onready var _Shooting_Enemy = load("res://src/enemies/shooting_enemy.tscn")
@onready var _Mini_Enemy = load("res://src/enemies/mini_enemy.tscn")

@onready var _Boss: Resource = load("res://src/enemies/boss/boss.tscn")


@onready var _Enemies: Array[Resource] = [
	_Little_Enemy,
	_Fast_Enemy,
	_Shooting_Enemy,
	_Mini_Enemy
]

var min_range_spawn: int = 400
var max_range_spawn: int = 500

var _player: Player
var spawn_rate: float = 1
var random: RandomNumberGenerator = RandomNumberGenerator.new()

var is_intro_over = false
var intro__enemy_arrived = false
@onready var intro__attack_timer: Timer = $Intro/AttackTimer

var is_outro = false
var is_boss = false

var boss: Enemy

const BOSS_SPAWN_TIME: float = 300
const MAX_HP: float = 35


func _ready() -> void:
	Context.set_context(self)
	
	_player = $Player
	_player.death.connect(start_game)
	$LevelUpMenu.connect_hud_to_player(_player, "choose_augment")
	_player.connect_player_to_hud($LevelUpMenu, "augment_chosen")
	$xpHUD.connect_hud_to_player(_player, "get_xp")
	$xpHUD.visible = false
	start_intro()



func start_boss():
	$Timers/SpawnEnemyTimer.stop()

	var length = random.randi_range(200, 400)
	var angle = random.randf_range(0, 2 * PI)
	var spawn_pos = _player.position + Vector2(cos(angle), sin(angle)) * length

	boss = _Boss.instantiate()

	$BossSpawnTmp.position = spawn_pos
	boss.init($BossSpawnTmp, $BossSpawnTmp.position, 0, 10000)
	boss.death.connect(start_outro)
	is_boss = true



	$Enemies.add_child(boss)


func spawn_enemy_outro():
	spawn_enemy(_Enemies[randomEnemy()], randomSpawn(boss.position))


func start_outro():
	is_outro = true
	_player.start_outro()

	$Camera.track(boss)
	create_tween().tween_property($Camera, "zoom", Vector2(.5, .5), 0.5).set_ease(Tween.EASE_IN)

	min_range_spawn = 200
	max_range_spawn = 300

	for i in range(30):
		for j in range(10):
			call_deferred("spawn_enemy_outro")

		$Timers/SpawnEnemyTimerOutro.start()
		await $Timers/SpawnEnemyTimerOutro.timeout

	$Timers/TimerOutro.start()
	await $Timers/TimerOutro.timeout

	get_tree().change_scene_to_file("res://src/main_menu/end_screen.tscn")


func start_intro():
	#print("START INTRO")
	set_up_player()
	$Camera.zoom = Vector2(3.0, 3.0)
	$Background.init(get_player_position())
	$Camera.track($Intro/CameraPosition)
	$Intro/Label.set("theme_override_colors/font_color", Color(1, 1, 1, 0))

	_player.get_node("SegwaySprite").visible = false

	var enemy = $Intro/Enemy
	enemy.init($Intro/EnemyTarget, $Intro/EnemySpawn.position, 0, 1)
	enemy.death.connect(end_intro)
	enemy.collision_layer = 0
	enemy.collision_mask = 0
	

func end_intro(_no_xp):
	# show_hud()
	# $Camera.zoom = Vector2(1.5, 1.5)
	set_up_player()
	set_up_enemies()
	is_intro_over = true

	# if not Input.is_action_just_pressed("segway"):
	# 	var weapons: Array[Node] = _player.get_node("Weapons").get_children()
	#
	# 	for weapon in weapons:
	# 		if weapon is Weapon:
	# 			weapon.sprite_node.visible = false


	$Camera.track(_player)
	create_tween().tween_property($Camera, "zoom", Vector2(1.5, 1.5), 0.5).set_ease(Tween.EASE_IN)
	create_tween().tween_property($Intro/Label, "theme_override_colors/font_color", Color(1, 1, 1, 0), 0.5).set_ease(Tween.EASE_IN)
	_player.post_intro()

	$TimerHUD.init()
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()

	$xpHUD.visible = true
	$xpHUD.refresh_xp(0, 1, 1)



func intro__attack():
	var weapons: Array[Node] = _player.get_node("Weapons").get_children()

	for weapon in weapons:
		if weapon is Weapon:
			weapon.sprite_node.visible = true
			weapon.position = weapon.pos_offset * Vector2.RIGHT
			weapon.sprite_node.rotation = 0
			weapon.force_shoot(Vector2.RIGHT)


func _process(_delta):
	if not is_boss and $TimerHUD.get_time() == 300:
		start_boss()
	
	spawn_rate = 1. / (max($TimerHUD.get_time(), 1.) ** 2)
	#print(spawn_rate)
	
	if is_intro_over:
		return
	
	if intro__enemy_arrived:
		if Input.is_action_just_pressed("segway") and intro__attack_timer.time_left == 0:
			_player.get_node("AnimatedSprite2D").play("Attack")
			intro__attack_timer.start()
			intro__attack_timer.timeout.connect(intro__attack)


	elif $Intro/Enemy.velocity == Vector2.ZERO:
		intro__enemy_arrived = true
		create_tween().tween_property($Intro/Label, "theme_override_colors/font_color", Color(1, 1, 1, 1), 0.5).set_ease(Tween.EASE_IN)



func start_game() -> void:
	set_up_player()
	set_up_enemies()
	$TimerHUD.init()
	$Background.init(get_player_position())
	$Timers/SpawnEnemyTimer.wait_time = spawn_rate
	$Timers/SpawnEnemyTimer.start()
	$xpHUD.refresh_xp(0, 1, 1)


func game_over(player: Node2D) -> void:
	player.queue_free()


func set_up_player() -> void:
	_player.init(self, Vector2.ZERO, DEFAULT_MAX_HP_PLAYER)
	$Camera.track(_player)


func set_up_enemies() -> void:
	for enemy in $Enemies.get_children():
		enemy.queue_free()

	spawn_rate = DEFAULT_SPAWN_RATE

func scaled_hp() -> float:
	var time: float = $TimerHUD.get_time()
	var hp_time = (1. - exp(- time / BOSS_SPAWN_TIME)) * MAX_HP
	#print("hp")
	#print(time / BOSS_SPAWN_TIME)
	#print(exp(- time / BOSS_SPAWN_TIME))
	#print(hp_time)
	return max(int(hp_time), 1)
	return max(hp_time + randi() % max(int(hp_time / 4.), 1), 1)

func spawn_enemy(EnemyClass: Resource, spawn_position: Vector2) -> void:
	var enemy = EnemyClass.instantiate()
	enemy.init(_player, spawn_position, 0, scaled_hp(), max(sqrt($TimerHUD.get_time()), 1))
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
	var length = random.randi_range(min_range_spawn, max_range_spawn)
	var angle = random.randf_range(0, 2 * PI)

	return origin + Vector2(cos(angle), sin(angle)) * length


func get_player_position() -> Vector2:
	return _player.position


func _on_spawn_enemy_timer_timeout():
	spawn_enemy(_Enemies[randomEnemy()], randomSpawn(_player.position))

