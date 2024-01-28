extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/AnimationPlayer.play("start")


func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://src/maps/first_map/map.tscn")

func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/how_to_play_menu.tscn")

func _on_parameters_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/settings.tscn") 
