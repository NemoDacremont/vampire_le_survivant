extends CanvasLayer

var time_passed: int
@onready var label: Node = $Label

func init():
	time_passed = 0
	
func get_time() -> int:
	return time_passed

func _on_timer_timeout():
	time_passed += 1
	var seconds: String
	if time_passed % 60 > 10:
		seconds = str(time_passed % 60)
	else:
		seconds = "0" + str(time_passed % 60)
	var minutes: String
	if time_passed / 60 > 10:
		minutes = str(time_passed / 60)
	else:
		minutes = "0" + str(time_passed / 60)
	label.text = minutes + " : " + seconds
