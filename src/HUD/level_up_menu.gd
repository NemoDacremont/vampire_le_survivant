extends CanvasLayer

signal augment_chosen(int)

@onready var firstChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button1/RichTextLabel
@onready var secondChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button2/RichTextLabel
@onready var thirdChoiceLabel: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button3/RichTextLabel
@onready var firstChoiceButton: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button1
@onready var secondChoiceButton: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button2
@onready var thirdChoiceButton: Node = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Button3

@onready var levelling_node: Node = Levelling

func _ready():
	clear_labels()
	visible = false

func connect_player(body: Node, function):
	self.connect("augment_choice", body.function)

func clear_labels():
	firstChoiceLabel.clear()
	firstChoiceLabel.append_text("[center]")
	firstChoiceButton.visible = false
	
	secondChoiceLabel.clear()
	secondChoiceLabel.append_text("[center]")
	secondChoiceButton.visible = false
	
	thirdChoiceLabel.clear()
	thirdChoiceLabel.append_text("[center]")
	thirdChoiceButton.visible = false

func _on_button_1_pressed():
	choice(0)

func _on_button_2_pressed():
	choice(1)

func _on_button_3_pressed():
	choice(2)

func choice(c: int):
	self.visible = false
	emit_signal("augment_chosen", c)
	get_tree().paused = false

func generate_choices():
	get_tree().paused = true
	self.visible = true
	clear_labels()
	var descriptions: Array[String] = levelling_node.new_level()
	
	var choice_number = len(descriptions)
	if choice_number == 0: push_error("LevelUpMenu.generate_choices: All augments have been attributed")
	if choice_number >= 1:
		firstChoiceButton.visible = true
		firstChoiceLabel.append_text(descriptions[0])
	if choice_number >= 2:
		secondChoiceButton.visible = true
		secondChoiceLabel.append_text(descriptions[1])
	if choice_number >= 3:
		thirdChoiceButton.visible = true
		thirdChoiceLabel.append_text(descriptions[2])


func connect_hud_to_player(body: Node, body_signal: String):
	body.connect(body_signal, generate_choices)
