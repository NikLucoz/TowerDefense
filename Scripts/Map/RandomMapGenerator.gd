extends TileMap

@onready var fast_noise_generator = FastNoiseLite.new()
@onready var camera_2d: Camera2D = $"../Camera2D"

const CASTLE = preload("res://Modules/TownHall/town_hall.tscn")
const FORAGE = preload("res://Scenes/Resources/forage.tscn")
const GOLD_ORE = preload("res://Scenes/Resources/gold_ore.tscn")
const TREE = preload("res://Scenes/Resources/tree.tscn")

@export_category("Map options")
var width: float = Global.map_size_width
var height: float = Global.map_size_height

@export_category("Spawn rate options")
@export var tree_spawn_rate: float = 12
@export var forage_spawn_rate: float = 2
@export var gold_ore_spawn_rate: float = 0.12
@export var decoration_spawn_rate: float = 9

var town_hall_position: Vector2
var town_hall_placed: bool = false
var town_hall_tiles: Array[Vector2] = []

const TILES = {
	0 : Vector2(0,0),	# Erba
	1 : Vector2(0,2),	# Sabbia
	2 : Vector2(0,1), 	# Terra
}

func _ready():
	camera_2d.enabled = false
	EventBus.connect("_save_triggered", save_on_file)
	connect("tree_exiting", save_on_exit)
	setup_fast_noise_generator()
	load_save()

func setup_fast_noise_generator():
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


# SAVE & LOAD SECTION
func load_save():
	var config_file: ConfigFile = GameManager.get_save_file()
	
	if config_file.has_section("map"):
		var map_seed = config_file.get_value("map", "seed", 313)
		fast_noise_generator.seed = map_seed
		town_hall_position = config_file.get_value("map", "town_hall_position")
		load_world(map_seed, town_hall_position.x, town_hall_position.y)
	else:
		generate_random_world()
	EventBus.emit_signal("_world_gen_finished")

func save_on_file(config_file: ConfigFile):
	config_file.set_value("map", "seed", fast_noise_generator.seed)
	config_file.set_value("map", "town_hall_position", town_hall_position)
	GameManager.get_save_load_manager().save_file_to_disk()

func save_on_exit():
	var config_file = GameManager.get_save_file()
	save_on_file(config_file)


# WORLD GEN SECTION 
func set_camera_limits():
	camera_2d.limit_top = int(-5 * 64)
	camera_2d.limit_bottom = int(((height) + 5) * 64)
	camera_2d.limit_left = int(-5 * 64)
	camera_2d.limit_right = int(((width) + 5) * 64)

func load_world(map_seed: int, town_hall_x: float, town_hall_y: float):
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	var config_file: ConfigFile = GameManager.get_save_file()
	var resources_positions: Array[Vector2] = []
	var resources_list = config_file.get_section_keys("resources")
	for key in resources_list:
		resources_positions.append(config_file.get_value("resources", key)["position"])
		
	fast_noise_generator.seed = map_seed
	
	place_town_hall(town_hall_x, town_hall_y)
	
	for x: int in range(0, width):
		for y: int in range(0, height):
			var atlas_tile_pos: Vector2
			var abs_noise: float = abs(fast_noise_generator.get_noise_2d(x, y))
			
			var tile_to_place: int = floori(abs_noise * 3)
			atlas_tile_pos = TILES[tile_to_place]
			
			set_cell(0, Vector2(x,y), 0, atlas_tile_pos)
			
			if not resources_positions.has(Vector2(x, y)) and not town_hall_tiles.has(Vector2(x, y)):
				match tile_to_place:
					0:
						place_grass_decoration(rng, x, y)
					1:
						place_sand_decoration(rng, x, y)
					2: 
						place_dirt_decoration(rng, x, y)
		

	print("Map creation ended with seed: " + str(fast_noise_generator.seed))
	set_camera_limits()

func generate_random_world():
	print("Starting map creation")
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	fast_noise_generator.seed = rng.randi_range(0, 500) # 153 148 481
	
	for x: int in range(0, width):
		for y: int in range(0, height):
			var atlas_tile_pos: Vector2
			var abs_noise: float = abs(fast_noise_generator.get_noise_2d(x, y))
			
			var tile_to_place: int = floori(abs_noise * 3)
			atlas_tile_pos = TILES[tile_to_place]
		
			set_cell(0, Vector2(x,y), 0, atlas_tile_pos)

	while not town_hall_placed:
		place_random_town_hall()

	place_resources_and_decorations(rng)

	print("Map creation ended with seed: " + str(fast_noise_generator.seed))
	set_camera_limits()

func place_random_town_hall():
	var x: int = randi_range(10, width - 10)
	var y: int = randi_range(10, height - 10)
	place_town_hall(x, y)

func place_town_hall(x: float, y: float):
	var first_tile: int = floori(
		abs(fast_noise_generator.get_noise_2d(x, y)) * 3
	)
		
	#if x >= (width / 2) - 10 or x <= -(width / 2) + 10:
		#return
	#if y == (height / 2) or y == -(height / 2):
		#return
	
	if first_tile == 0 && not town_hall_placed:
		town_hall_tiles.append(Vector2(x, y))
		
		for hx: int in range(x-5, x+5):
			for hy: int in range(y-5, y+5):
				var th_abs_noise: float = abs(fast_noise_generator.get_noise_2d(hx, hy))
				var th_tile: int = floori(th_abs_noise * 3)
				if th_tile == 0:
					town_hall_tiles.append(Vector2(hx, hy))
				else:
					return

		town_hall_placed = true
		#Instanciate TownHall
		var instance = CASTLE.instantiate()
		instance.position = Vector2(x * 64, y * 64).floor()
		get_parent().add_child.call_deferred(instance)
		GameManager.get_entity_manager().town_hall = instance
		town_hall_position = Vector2(x, y)
		camera_2d.translate(Vector2(x * 64, y * 64))
		camera_2d.enabled = true
	else:
		return

func place_resources_and_decorations(rng: RandomNumberGenerator):
	for x: int in range(0, width):
		for y: int in range(0, height):
			var abs_noise: float = abs(fast_noise_generator.get_noise_2d(x, y))
			var tile_to_place: int = floori(abs_noise * 3)
			
			match tile_to_place:
				0:
					if not town_hall_tiles.has(Vector2(x, y)):
						if not place_resource(rng, x, y, TREE, tree_spawn_rate):
							if not place_resource(rng, x, y, FORAGE, forage_spawn_rate):
								place_grass_decoration(rng, x, y)
				1:
					if not place_resource(rng, x, y, GOLD_ORE, gold_ore_spawn_rate):
						place_sand_decoration(rng, x, y)
				2: 
					place_dirt_decoration(rng, x, y)

func place_resource(rng: RandomNumberGenerator, x: int, y: int, RESOURCE: PackedScene, resource_spawn_rate: float) -> bool:
	# Per non piazzare risorse sul bordo della mappa
	if x == 0 or x == width:
		return false
	if y == 0 or y == height:
		return false
		
	rng.randomize()
	var rng_value = rng.randf_range(0.0, 99.9)
	if rng_value <= resource_spawn_rate:
		var instance = RESOURCE.instantiate()
		if instance.is_in_group("Forage"):
			var random: int = rng.randi_range(1, 100)
			if random < 40:
				instance.type = Global.forage_type.BERRY
			else:
				instance.type = Global.forage_type.MUSHROOM

		instance.position = Vector2(x * 64, y * 64).floor()
		var entity_manager: EntityManager = GameManager.get_entity_manager()
		entity_manager.add_entity(instance, true)
		return true
	return false

func place_grass_decoration(rng: RandomNumberGenerator, x: int, y: int):
	var rng_decoration_value: int = rng.randi_range(0, 99)
	if rng_decoration_value < decoration_spawn_rate:
		var rng_tile_decoration = rng.randi_range(1, 3)
		set_cell(1, Vector2(x,y), 0, Vector2(rng_tile_decoration, 0))

func place_sand_decoration(rng: RandomNumberGenerator, x: int, y: int):
	var rng_decoration_value: int = rng.randi_range(0, 99)
	if rng_decoration_value < decoration_spawn_rate:
		var rng_tile_decoration = rng.randi_range(1, 2)
		set_cell(1, Vector2(x,y), 0, Vector2(rng_tile_decoration, 2))

func place_dirt_decoration(rng: RandomNumberGenerator, x: int, y: int):
	var rng_decoration_value: int = rng.randi_range(0, 99)
	if rng_decoration_value < decoration_spawn_rate:
		var rng_tile_decoration = rng.randi_range(1, 2)
		set_cell(1, Vector2(x,y), 0, Vector2(rng_tile_decoration, 1))
