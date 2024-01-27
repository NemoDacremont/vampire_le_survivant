extends TileMap
class_name Background

var noise: Noise

var _center_position: Vector2 = Vector2.ZERO

var tile_width: int = 10
var tile_height: int = 10

var width: int = 75
var height: int = 50

var origin: Vector2

var maps: Array[TileMap]


func init(init_center_position: Vector2):
	_center_position = init_center_position
	origin = init_center_position - (height / 2.0) * Vector2.UP - (width / 2.0) * Vector2.RIGHT

	noise = FastNoiseLite.new()
	noise.seed = randi();
	noise.frequency = 0.01

	maps = $BlocksMap.get_tilemaps()
	load_all_chunks()


func generate_chunk(pos: Vector2i) -> TileMap:
	return maps[round(noise.get_noise_2d(pos.x / tile_width, pos.y / tile_height) * len(maps))]


func load_chunk(pos: Vector2i):
	var tilemap: TileMap = generate_chunk(pos)
	var tmp_pos: Vector2
	var tiledata: TileData
	var sourceid: int
	var source: Vector2

	for x in range(tile_width):
		for y in range(tile_height):
			for z in range(tilemap.get_layers_count()):
				tmp_pos = Vector2(x, y)
				# tiledata = tilemap.get_cell_tile_data(z, tmp_pos)
				sourceid = tilemap.get_cell_source_id(z, tmp_pos)
				source = tilemap.get_cell_atlas_coords(z, tmp_pos)

				if (sourceid >= 0):
					print("Set: ", Vector2i(pos.x * tile_width + x, pos.y * tile_height), ", ", z, " ; ", sourceid)
					set_cell(z, Vector2i(pos.x * tile_width + x, pos.y * tile_height), sourceid)



func load_all_chunks():
	for x in range(width):
		for y in range(height):
			load_chunk(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	

	pass
