extends CanvasLayer

@onready var firstChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button1/RichTextLabel
@onready var secondChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button2/RichTextLabel
@onready var thirdChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button3/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_labels()
	visible = false

func clear_labels():
	firstChoiceLabel.clear()
	firstChoiceLabel.append_text("[center]")
	secondChoiceLabel.clear()
	secondChoiceLabel.append_text("[center]")
	thirdChoiceLabel.clear()
	thirdChoiceLabel.append_text("[center]")


func _on_button_1_pressed():
	choice(1)

func _on_button_2_pressed():
	choice(2)

func _on_button_3_pressed():
	choice(3)

func choice(choice: int):
	print("choix "+str(choice))
	self.visible = false
	get_tree().paused = false

func generate_choices():
	self.visible = true
	print("ratio")
	clear_labels()
	#choice(0)
