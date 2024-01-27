extends Node2D
class_name BlocksMap


func get_tilemaps() -> Array[TileMap]:
	var out: Array[TileMap] = []
	var children: Array[Node] = get_children()

	for child in children:
		if child is TileMap:
			out.append(child)

	return out

	
