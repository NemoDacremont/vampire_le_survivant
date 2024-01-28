extends Node

enum {GUN=0, ASSAULT, SHOTGUN, SNIPER, NUMBER_OF_WEAPONS}
enum {FIRE_RATE=0, DAMAGE, PIERCING, NUMBER, SPRAY}

#Level 0 <=> Player hasn't the weapon
var weapons_levels: Array[int] = [1, 0, 0, 0]
const weapons_max_levels: Array[int] = [1, 1, 1, 1]

var choice: Array[int] = [0, 0, 0]

var scaling: Array = [\
[[], [1, 10, 1]],\
[[], [5, 3, 1]],\
[[], [0.8, 15, 1, 3]],\
[[], [0.5, 50, -1]]\
]

var level_description: Array = [\
["","Unlock [color=purple]Pistol[/color]"],\
["","Unlock [color=purple]Assault rifle[/color]"],\
["","Unlock [color=purple]Shotgun[/color]"],\
["","Unlock [color=purple]Sniper[/color]"]\
]

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
