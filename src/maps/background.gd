extends Node2D
class_name Background

var noise: Noise

var _center_position: Vector2 = Vector2.ZERO

var tile_width: int = 160
var tile_height: int = 160

var width: int = 16
var height: int = 8

var origin: Vector2
var player_old_pos: Vector2i = Vector2i.ZERO
var player_cur_pos: Vector2i = Vector2i.ZERO

@onready var blocks_node = $BlocksMap
@onready var tilemaps_node: Node = $tilemaps
var maps: Array[Resource]
var probas: Array[float]


func init(init_center_position: Vector2):
	blocks_node.init()

	_center_position = init_center_position
	origin = init_center_position - (height / 2.0) * Vector2.UP - (width / 2.0) * Vector2.RIGHT

	noise = FastNoiseLite.new()
	noise.seed = randi();
	noise.frequency = 0.5

	maps = blocks_node.get_tilemaps()
	load_all_chunks()


func load_chunk(pos: Vector2i) -> void:
	var n: float = (noise.get_noise_2d(pos.x, pos.y) + 1) / 2
	var tilemap_res: Resource = blocks_node.get_tilemap(n)
	var tilemap: TileMap = tilemap_res.instantiate()

	tilemap.position = Vector2(pos.x * tile_width, pos.y * tile_height)
	tilemaps_node.add_child(tilemap)


func load_all_chunks():
	for x in range(width):
		for y in range(height):
			load_chunk(Vector2i(x - width / 2, y - height / 2))


func update_chunks(diff: Vector2i) -> void:
	var chunks = tilemaps_node.get_children()
	var pos: Vector2i
	print(diff)

	for chunk in chunks:
		pos = Vector2i(chunk.position.x / tile_width, chunk.position.y / tile_height)

		if diff.x > 0 && pos.x - player_cur_pos.x - width / 2 == diff.x:
			chunk.queue_free()

		elif diff.x < 0 && player_cur_pos.x - pos.x - width / 2 - 2 == diff.x:
			chunk.queue_free()

		if diff.y < 0 && player_cur_pos.y - pos.y - height / 2 - 2 == diff.y:
			chunk.queue_free()

		elif diff.y > 0 && pos.y - player_cur_pos.y - height / 2 == diff.y:
			chunk.queue_free()


	if diff.x < 0:
		for x in range(abs(diff.x)):
			for y in range(height):
				load_chunk(Vector2i(player_cur_pos.x + width / 2 + x - 1, player_cur_pos.y + y - height / 2))

	elif diff.x > 0:
		for x in range(diff.x):
			for y in range(height):
				load_chunk(Vector2i(player_cur_pos.x - width / 2 - x, player_cur_pos.y + y - height / 2))


	if diff.y < 0:
		for y in range(abs(diff.y)):
			for x in range(width):
				load_chunk(Vector2i(player_cur_pos.x + x - width / 2, player_cur_pos.y + height / 2 + y - 1))

	elif diff.y > 0:
		for y in range(diff.y):
			for x in range(width):
				load_chunk(Vector2i(player_cur_pos.x + x - width / 2, player_cur_pos.y - height / 2 - y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player_cur_pos = round(Context.get_player_position() / tile_width)

	if (player_cur_pos != player_old_pos):
		var diff = player_old_pos - player_cur_pos
		update_chunks(diff)
		player_old_pos = player_cur_pos

