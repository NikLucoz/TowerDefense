extends TileMap

const TREE = preload("res://Scenes/Resources/tree.tscn")
const FORAGE = preload("res://Scenes/Resources/forage.tscn")
const CASTLE = preload("res://Scenes/Level/castle.tscn")

@onready var fast_noise_generator = FastNoiseLite.new()
@onready var camera_2d = $"../Camera2D"

@export_category("Map options")
@export var width: float = 100
@export var height: float = 100

@export_category("Spawn rate options")
@export var tree_spawn_rate: int = 12
@export var forage_spawn_rate: int = 2
@export var decoration_spawn_rate: int = 5

var town_hall_placed: bool = false
var town_hall_tiles: Array[Vector2] = []

const TILES = {
	0 : Vector2(0,0),	# Erba
	1 : Vector2(0,2),	# Sabbia
	2 : Vector2(0,1), 	# Terra
}

signal world_gen_finished()

func _ready():
	camera_2d.enabled = false
	generate_world()

func generate_world():
	print("Starting map creation")
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	fast_noise_generator.seed = rng.randi_range(0, 500) # 153 148 481
	fast_noise_generator.noise_type = FastNoiseLite.TYPE_CELLULAR
	fast_noise_generator.frequency = 0.04
	
	fast_noise_generator.fractal_type = FastNoiseLite.FRACTAL_NONE
	fast_noise_generator.fractal_octaves = 3
	fast_noise_generator.fractal_lacunarity = 2.000
	fast_noise_generator.fractal_gain = 0.800
	fast_noise_generator.fractal_weighted_strength = 0.00
	fast_noise_generator.fractal_ping_pong_strength = 2.000

	fast_noise_generator.cellular_distance_function = FastNoiseLite.DISTANCE_HYBRID
	fast_noise_generator.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	fast_noise_generator.cellular_jitter = 1.000

	fast_noise_generator.domain_warp_type = FastNoiseLite.DOMAIN_WARP_SIMPLEX
	fast_noise_generator.domain_warp_amplitude = 50.000
	fast_noise_generator.domain_warp_frequency = 0.010
	
	fast_noise_generator.domain_warp_fractal_type = FastNoiseLite.DOMAIN_WARP_FRACTAL_INDEPENDENT
	fast_noise_generator.domain_warp_fractal_gain = 0.500
	fast_noise_generator.domain_warp_fractal_octaves = 3
	fast_noise_generator.domain_warp_fractal_lacunarity = 1.200
	
	for x in range(-(width/2), width/2):
		for y in range(-(height/2), height/2):
			var atlas_tile_pos: Vector2
			var abs_noise = abs(fast_noise_generator.get_noise_2d(x, y))
			
			var tile_to_place = floori(abs_noise * 3)
			atlas_tile_pos = TILES[tile_to_place]
		
			set_cell(0, Vector2(x,y), 0, atlas_tile_pos)

	while not town_hall_placed:
		place_town_hall()

	for x in range(-(width/2), width/2):
		for y in range(-(height/2), height/2):
			var abs_noise = abs(fast_noise_generator.get_noise_2d(x, y))
			var tile_to_place = floori(abs_noise * 3)
			
			match tile_to_place:
				0:
					if not town_hall_tiles.has(Vector2(x, y)):
						if not place_resource(rng, x, y, TREE, tree_spawn_rate):
							if not place_resource(rng, x, y, FORAGE, forage_spawn_rate):
								place_grass_decoration(rng, x, y)
				1:
					place_sand_decoration(rng, x, y)
				2: 
					place_dirt_decoration(rng, x, y)

	print("Map creation ended with seed: " + str(fast_noise_generator.seed))
	world_gen_finished.emit()

func place_town_hall():
	var x = randi_range(floor(-width/2), floor(width/2))
	var y = randi_range(floor(-height/2), floor(height/2))
	var first_tile = floori(
		abs(fast_noise_generator.get_noise_2d(x, y)) * 3
	)
		
	if x >= (width / 2) - 10 or x <= -(width / 2) + 10:
		return
	if y == (height / 2) or y == -(height / 2):
		return
	
	if first_tile == 0 && not town_hall_placed:
		town_hall_tiles.append(Vector2(x, y))
		
		for hx in range(x-5, x+5):
			for hy in range(y-5, y+5):
				var th_abs_noise = abs(fast_noise_generator.get_noise_2d(hx, hy))
				var th_tile = floori(th_abs_noise * 3)
				if th_tile == 0:
					town_hall_tiles.append(Vector2(hx, hy))
				else:
					return

		town_hall_placed = true
		#Instanciate TownHall
		var instance = CASTLE.instantiate()
		instance.position = Vector2(x * 64, y * 64).floor()
		get_parent().add_child.call_deferred(instance)
		GameManager.town_hall = instance
		camera_2d.translate(Vector2(x * 64, y * 64))
		camera_2d.enabled = true
	else:
		return

func place_resource(rng: RandomNumberGenerator, x: int, y: int, RESOURCE: PackedScene, resource_spawn_rate: int) -> bool:
	# Per non piazzare risorse sul bordo della mappa
	if x == (width / 2) or x == -(width / 2):
		return false
	if y == (height / 2) or y == -(height / 2):
		return false

	var rng_value = rng.randi_range(0, 99)
	if rng_value <= resource_spawn_rate:
		var instance = RESOURCE.instantiate()
		if instance.is_in_group("Forage"):
			var random = rng.randi_range(1, 100)
			if random < 40:
				instance.type = Forage.forage_type.BERRY
			else:
				instance.type = Forage.forage_type.MUSHROOM

		instance.position = Vector2(x * 64, y * 64).floor()
		get_parent().add_child.call_deferred(instance)
		return true
	return false

func place_grass_decoration(rng: RandomNumberGenerator, x: int, y: int):
	var rng_decoration_value = rng.randi_range(0, 99)
	if rng_decoration_value < decoration_spawn_rate:
		var rng_tile_decoration = rng.randi_range(1, 3)
		set_cell(1, Vector2(x,y), 0, Vector2(rng_tile_decoration, 0))

func place_sand_decoration(rng: RandomNumberGenerator, x: int, y: int):
	var rng_decoration_value = rng.randi_range(0, 99)
	if rng_decoration_value < decoration_spawn_rate:
		var rng_tile_decoration = rng.randi_range(1, 2)
		set_cell(1, Vector2(x,y), 0, Vector2(rng_tile_decoration, 2))

func place_dirt_decoration(rng: RandomNumberGenerator, x: int, y: int):
	var rng_decoration_value = rng.randi_range(0, 99)
	if rng_decoration_value < decoration_spawn_rate:
		var rng_tile_decoration = rng.randi_range(1, 2)
		set_cell(1, Vector2(x,y), 0, Vector2(rng_tile_decoration, 1))
