extends Enemy
class_name Boss

@onready var bullets_node: Node = $Bullets

var Shotgun: Resource = preload("res://src/enemies/boss/boss_shotgun.tscn")
var _Fireball: Resource = preload("res://src/enemies/boss/boss_bullets.tscn")
var _Text: Resource = preload("res://src/enemies/boss/boss_text.tscn")

var shoot_direction: Vector2
var damage: float = 20


func attack():
	var player_pos: Vector2 = Context.get_player_position()

	var bullet: EnemyBullet = _Fireball.instantiate()

	player_pos = Context.get_player_position()
	shoot_direction = (player_pos - position).normalized()

	bullet.init(position, shoot_direction, damage, 200)

	bullets_node.add_child(bullet)



func init(target: Node2D, spawn_position: Vector2, speed: float, hp: float) -> void:
	super(target, spawn_position, speed, hp)

	$AttackTimer.timeout.connect(attack)


func _physics_process(_delta):
	pass


func spawn_text():
	var text: BossText = _Text.instantiate()

	var angle: float = randf() * PI
	var speed: float = randf() * 20

	var v0: Vector2 = speed * Vector2(cos(angle), sin(angle))

	text.init("I'm already happy morron", v0, position)

	$Text.add_child(text)


func _on_health_component_health_lost(_hp: float):
	spawn_text()


func bring_weapons():
	for i in range(10):
		var weapon = Shotgun.instantiate()
		$Weapons.add_child(weapon)
		weapon.init(self)
		weapon.enable_weapon()

		$WeaponSpawnTimer.start(randf() * 0.1 + 0.1)
		await $WeaponSpawnTimer.timeout


func _on_health_component_death():
	$AttackTimer.stop()
	$BodyCollisionComponent.collision_layer = 0

	$Smiley.visible = true
	bring_weapons()
	emit_signal("death")
