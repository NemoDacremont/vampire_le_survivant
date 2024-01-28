extends Node

var _context

func set_context(map: Node2D):
	_context = map


func get_player_position() -> Vector2:
	if _context.get_player_position:
		return _context.get_player_position()

	return Vector2.ZERO


func get_enemies():
	var enemies_node = _context.get_node("Enemies")
	return enemies_node.get_children()


func get_nearest_enemy(pos: Vector2) -> Vector2:
	var enemies_node = _context.get_node("Enemies")

	if not enemies_node:
		return Vector2.RIGHT

	var enemies = enemies_node.get_children()

	if len(enemies) == 0:
		return Vector2.RIGHT

	var nearest = enemies[0]
	var min_dist: float = 2**32 #pos.distance_to(nearest.position)
	var dist: float

	for enemy in enemies:
		dist = pos.distance_to(enemy.position)

		if (enemy.is_alive && dist < min_dist):
			nearest = enemy
			min_dist = dist

	return nearest.position

