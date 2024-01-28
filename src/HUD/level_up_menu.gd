extends CanvasLayer

@onready var firstChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button1/RichTextLabel
@onready var secondChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button2/RichTextLabel
@onready var thirdChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button3/RichTextLabel
@onready var levelling_node: Node = Levelling

func _ready():
	clear_labels()
	visible = false

func clear_labels():
	firstChoiceLabel.clear()
	firstChoiceLabel.append_text("[center]")
	firstChoiceLabel.visible = false
	secondChoiceLabel.clear()
	secondChoiceLabel.append_text("[center]")
	secondChoiceLabel.visible = false
	thirdChoiceLabel.clear()
	thirdChoiceLabel.append_text("[center]")
	thirdChoiceLabel.visible = false

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
	get_tree().paused = true
	self.visible = true
	clear_labels()
	var descriptions: Array[String] = levelling_node.new_level()
	var len = len(descriptions)
	if len == 0: push_error("LevelUpMenu.generate_choices: All augments have been attributed")
	if len >= 1:
			firstChoiceLabel.visible = true
			firstChoiceLabel.append_text(descriptions[0])
	if len >= 2:
			secondChoiceLabel.visible = true
			secondChoiceLabel.append_text(descriptions[1])
	if len >= 3:
			thirdChoiceLabel.visible = true
			thirdChoiceLabel.append_text(descriptions[2])
	

func connect_hud_to_player(body: Node, body_signal: String):
	body.connect(body_signal, generate_choices)
