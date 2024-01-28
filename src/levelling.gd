extends Node

enum {PISTOL=0, ASSAULT, SHOTGUN, SNIPER, NUMBER_OF_WEAPONS}
enum {FIRE_RATE=0, DAMAGE, PIERCING, NUMBER, SPRAY}

var choice: Array[int] = [0, 0, 0]

var scaling: Array = [\
[[1., 5., 1], [1., 10., 1], [1.25, 10., 1], [1.25, 15., 1], [1.75, 15., 1], [1.75, 15., 3], [5., 50., 10]],\
[[2., 1., 1], [3., 1., 1], [5., 2., 1], [5., 3., 4], [8., 5., 10], [8., 7., 10], [8., 15., 10]],\
[[0.8, 5., 1, 3., PI / 6], [0.8, 10., 1, 3., PI / 6], [0.8, 15., 3, 4., PI / 6], [0.6, 20., 5, 5., PI / 6], \
[0.5, 25., 5, 5., PI / 3], [0.75, 30., 5, 6., PI / 3], [0.5, 20., 10, 45., 2 * PI]],\
[[0.4, 40., -1], [0.5, 50., -1], [0.6, 55, -1], [0.6, 100., -1], [0.8, 120., -1], [1., 150., -1], [2., 600., -1]]\
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
	var text: String
	var stats_changed: int
	for i in range(NUMBER_OF_WEAPONS):
		for j in range(1, len(scaling[i])):
			text = weapon_to_string(i) + ": "
			stats_changed = 0
			for k in range(min(4, len(scaling[i][j]))):
				if scaling[i][j][k] < scaling[i][j - 1][k]:
					text += "Decrease "+stat_to_string(k)+": "+str(scaling[i][j - 1][k])+" -> [color=red]"+str(scaling[i][j][k])+"[/color]   "
					stats_changed += 1
				if scaling[i][j][k] > scaling[i][j - 1][k]:
					text += "Increase "+stat_to_string(k)+": "+str(scaling[i][j - 1][k])+" -> [color=green]"+str(scaling[i][j][k])+"[/color]   "
					stats_changed += 1
				if stats_changed == 2:
					text += "\n"
			level_description[i].append(text)

func weapon_to_string(weapon: int) -> String:
	match weapon:
		PISTOL:
			return "[color=purple]Pistol[/color]"
		ASSAULT:
			return "[color=purple]Assault[/color]"
		SHOTGUN:
			return "[color=purple]Shotgun[/color]"
		SNIPER:
			return "[color=purple]Sniper[/color]"
		_:
			return "flop"

func stat_to_string(stat: int) -> String:
	match stat:
		FIRE_RATE:
			return "fire rate"
		DAMAGE:
			return "damage"
		PIERCING:
			return "piercing power"
		NUMBER:
			return "number of bullets"
		_:
			return "ratio"

func reset_levels():
	for i in range(NUMBER_OF_WEAPONS):
		weapons_levels[i] = 0
	weapons_levels[0] = 1

func max_levels_reached() -> int:
	var sum: int
	for m in weapons_max_levels:
		sum += m
	return sum

func choice_to_weapon(choice_index: int) -> int:
	return choice[choice_index]

func level_up_weapon(weapon: int) -> Array:
	if weapons_levels[weapon] < weapons_max_levels[weapon]:
		#print("new stats:")
		#print(scaling[weapon][weapons_levels[weapon]])
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
		#print(weapons_available)
	var descriptions: Array[String]
	for i in range(len(weapons_available)):
		descriptions.append(next_level_description(weapons_available[i]))
		choice[i] = weapons_available[i]
	return descriptions
