extends CanvasLayer

var time_passed: int
@onready var label: Node = $Label

func init():
	create_tween().tween_property($Label, "position:y", 10, 0.5).set_ease(Tween.EASE_IN)
	time_passed = 0
	label.text = "00 : 00"
	$Timer.start(0)

func get_time() -> int:
	return time_passed

func _on_timer_timeout():
	time_passed += 1
	var seconds: String
	if time_passed % 60 >= 10:
		seconds = str(time_passed % 60)
	else:
		seconds = "0" + str(time_passed % 60)
	var minutes: String
	if time_passed / 60 >= 10:
		minutes = str(time_passed / 60)
	else:
		minutes = "0" + str(time_passed / 60)
	label.text = minutes + " : " + seconds
