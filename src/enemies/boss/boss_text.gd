extends Node2D
class_name BossText


const grav: float = 98
var a: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready():
	create_tween().tween_property($Label, "theme_override_colors/font_color", Color(1, 1, 1, 0), 1).set_ease(Tween.EASE_IN)
	$Timer.start()
	$Timer.timeout.connect(fre)


func init(text: String, v0: Vector2, p0: Vector2):
	$Label.text = text
	$Label.rotation = atan2(v0.y, v0.x) - PI / 2
	velocity = v0
	position = p0



func _physics_process(delta):
	a = grav * Vector2.DOWN
	velocity += a * delta

	position += velocity * delta



func fre():
	queue_free()



