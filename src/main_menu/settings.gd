extends CanvasLayer


func _ready():
	$AnimatedSprite2D.play("kneel")
		

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/main_menu.tscn") 
