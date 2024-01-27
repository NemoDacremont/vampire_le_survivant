extends Node

enum {GUN=0, ASSAULT, SHOTGUN, SNIPER, NUMBER_OF_WEAPONS}
enum {FIRE_RATE=0, DAMAGE, PIERCING, NUMBER}

#Level 0 <=> Player hasn't the weapon
var weapons_levels: Array[int]
const weapons_max_levels: Array[int] = [1, 1, 1, 1]

var scaling: Array = [\
[[], [1, 10, 1]],\
[[], [5, 3, 1]],\
[[], [0.8, 15, 1, 3]],\
[[], [0.5, 50, -1]]\
]

var level_description: Array = [\
["","Unlock [color=purple]Gun[/color]"],\
["","Unlock [color=purple]Assault rifle[/color]"],\
["","Unlock [color=purple]Shotgun[/color]"],\
["","Unlock [color=purple]Sniper[/color]"]\
]

func level_up_weapon(weapon: int) -> Array[int]:
	if weapons_levels[weapon] < weapons_max_levels[weapon]:
		weapons_levels[weapon] += 1
	return scaling[weapon][weapons_levels[weapon]]

func next_level_description(weapon: int) -> String:
	if weapons_levels[weapon + 1] < weapons_max_levels[weapon + 1]:
		return level_description[weapon + 1][weapons_levels[weapon + 1]]
	else:
		return "Error, max level exceeded"

func init():
	for i in range(NUMBER_OF_WEAPONS):
		weapons_levels[i] = 0
