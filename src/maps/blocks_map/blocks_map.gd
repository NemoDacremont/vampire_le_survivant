extends Node2D
class_name BlocksMap


var tilemaps: Array[Resource] = [
	preload("res://src/maps/blocks_map/block_1.tscn"),
	preload("res://src/maps/blocks_map/block_2.tscn"),
	preload("res://src/maps/blocks_map/block_3.tscn"),
	preload("res://src/maps/blocks_map/block_4.tscn"),
	preload("res://src/maps/blocks_map/block_5.tscn"),
	preload("res://src/maps/blocks_map/block_6.tscn"),
	preload("res://src/maps/blocks_map/block_7.tscn"),
	preload("res://src/maps/blocks_map/block_8.tscn"),
	preload("res://src/maps/blocks_map/block_9.tscn"),
	preload("res://src/maps/blocks_map/block_10.tscn"),
	preload("res://src/maps/blocks_map/block_11.tscn"),
	preload("res://src/maps/blocks_map/block_12.tscn"),
	preload("res://src/maps/blocks_map/block_13.tscn"),
	preload("res://src/maps/blocks_map/block_14.tscn"),
	preload("res://src/maps/blocks_map/block_15.tscn"),
]


var probas: Array[float] = [
	1,
	10,
	10,
	10,
	10,
	10,
	200,
	100,
	100,
	10,
	50,
	10,
	50,
	10,
	50
]

var sum: float = -1

func init():
	sum = 0

	for proba in probas:
		sum += proba

	probas[0] = probas[0] / sum
	for i in range(1, len(probas)):
		probas[i] = probas[i - 1] + probas[i] / sum


func get_tilemaps() -> Array[Resource]:
	return tilemaps


# 0 <= n <= 1; randomly generated number
func get_tilemap(n: float) -> Resource:
	for i in range(len(probas)):
		if n <= probas[i]:
			return tilemaps[i]
	
	return tilemaps[0]


func get_probas() -> Array[float]:
	return probas

	
