extends Node

enum {GUN=0, ASSAULT, SHOTGUN, SNIPER, NUMBER_OF_WEAPONS}
enum {FIRE_RATE=0, DAMAGE, PIERCING, NUMBER, SPRAY}

var choice: Array[int] = [0, 0, 0]

var scaling: Array = [\
[[1, 5, 1], [1, 10, 1], [1.25, 10, 1], [1.25, 15, 1], [1.75, 15, 1], [1.75, 15, 3], [5, 100, 10]],\
[[4, 3, 1], [5, 3, 1], [5, 5, 1], [5, 5, 4], [8, 5, 10], [10, 15, 10], [20, 50, 10]],\
[[0.8, 5, 1, 3, PI / 6], [0.8, 10, 1, 3, PI / 6], [0.8, 15, 3, 4, PI / 6], [0.6, 20, 5, 5, PI / 6], \
[0.5, 25, 5, 5, PI / 3], [0.75, 30, 5, PI / 3], [2, 35, 10, 90, 2 * PI]],\
[[0.4, 40, -1], [0.5, 50, -1], [0.6, 55, -1], [0.6, 100, -1], [0.8, 120, -1], [1, 150, -1], [3, 1000, -1]]\
]

#Level 0 <=> Player hasn't the weapon
var weapons_levels: Array[int] = [1, 0, 0, 0]
var weapons_max_levels: Array[int] = [len(scaling[0]), len(scaling[1]), len(scaling[2]), len(scaling[3])]

var level_description: Array = [\
["","Unlock [color=purple]Pistol[/color]"],\
["","Unlock [color=purple]Assault rifle[/color]"],\
["","Unlock [color=purple]Shotgun[/color]"],\
["","Unlock [color=purple]Sniper[/color]"]\
]

func _ready():
	for i in range(NUMBER_OF_WEAPONS):
		for j in len(scaling[i]):
			

func choice_to_weapon(choice_index: int) -> int:
	print(choice)
	return choice[choice_index]

func level_up_weapon(weapon: int) -> Array:
	if weapons_levels[weapon] < weapons_max_levels[weapon]:
		print("new stats:")
		print(scaling[weapon][weapons_levels[weapon]])
		weapons_levels[weapon] += 1
		return scaling[weapon][weapons_levels[weapon] - 1]
	else:
		return scaling[weapon][weapons_levels[weapon] - 1]

func next_level_description(weapon: int) -> String:
	if weapons_levels[weapon] < weapons_max_levels[weapon]:
		return level_description[weapon][weapons_levels[weapon] + 1]
	else:
		return "Error, max level exceeded"

func init():
	for i in range(NUMBER_OF_WEAPONS):
		weapons_levels[i] = 0

func new_level() -> Array[String]:
	var weapons_available: Array
	for i in range(NUMBER_OF_WEAPONS):
		if weapons_levels[i] < weapons_max_levels[i]:
			weapons_available.append(i)
	var delete_index: int
	while len(weapons_available) > 3:
		delete_index = randi() % len(weapons_available)
		weapons_available.remove_at(delete_index)
		print(weapons_available)
	var descriptions: Array[String]
	for i in range(len(weapons_available)):
		descriptions.append(next_level_description(weapons_available[i]))
		choice[i] = weapons_available[i]
	print("oui : ")
	print(descriptions)
	return descriptions
