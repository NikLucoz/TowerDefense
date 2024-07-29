class_name EntityManager extends Node

const TREE = preload("res://Scenes/Resources/tree.tscn")
const FORAGE = preload("res://Scenes/Resources/forage.tscn")
const GOLD_ORE = preload("res://Scenes/Resources/gold_ore.tscn")
const LUMBERJACK = preload("res://Scenes/Villagers/wood_cutter.tscn")
const FORAGER = preload("res://Scenes/Villagers/forager.tscn")
const GOLD_FINDER = preload("res://Scenes/Villagers/gold_finder.tscn")
const HOUSE = preload("res://Modules/House/House.tscn")

var entities: Array[Node] = []
var level_instance: Node
var level_tilemap: TileMap
var resource_parent_node: Node2D
var town_hall: Node2D

@export var tree_list: Array[GameTree]
@export var forage_list: Array[Forage]
@export var goldores_list: Array[GoldOres]

func _ready():
	level_instance = get_tree().root.get_node("./Level")
	level_tilemap = level_instance.get_node("./TileMap")
	EventBus.connect("_save_triggered", save_on_file)
	EventBus.connect("_trigger_load", load_save)
	connect("tree_exiting", save_on_exit)
	
	resource_parent_node = Node2D.new()
	resource_parent_node.y_sort_enabled = true
	resource_parent_node.z_index = 1
	level_instance.add_child.call_deferred(resource_parent_node)

# SAVE AND LOAD SECTION
func load_save():
	var config_file: ConfigFile = GameManager.get_save_file()
	load_game_resources(config_file)
	load_villagers(config_file)
	load_structures(config_file)

func load_structures(config_file: ConfigFile):
	if config_file.has_section("structures"):
		var structures_key = config_file.get_section_keys("structures")
		for key in structures_key:
			var dict: Dictionary = config_file.get_value("structures", key)
			var structure_type: Global.structure_type = dict["structure_type"]
			var structure_pos: Vector2 = dict["position"]
			
			var entity_to_instanciate
			match structure_type:
				Global.structure_type.HOUSE:
					entity_to_instanciate = HOUSE

			var instance = spawn_entity_on_pos(entity_to_instanciate, structure_pos.x, structure_pos.y)
			instance.name = key

func load_game_resources(config_file: ConfigFile):
	if config_file.has_section("resources"):
		var resources_list = config_file.get_section_keys("resources")
		for key in resources_list:
			var res = config_file.get_value("resources", key)

			var resource_to_instanciate: PackedScene
			
			match res["resource_type"]:
				Global.resource_type.FORAGE:
					resource_to_instanciate = FORAGE
				Global.resource_type.TREE:
					resource_to_instanciate = TREE
				Global.resource_type.GOLDORE:
					resource_to_instanciate = GOLD_ORE
			
			var instance = resource_to_instanciate.instantiate()
			add_entity(instance, true)
			
			instance.position = res["position"]
			var damage_handler: DamageHandler = instance.get_node("./DamageHandler")
			damage_handler.set_current_health(res["current_health"])
			
			if instance.is_in_group("Forage"):
				instance.type = res["forage_type"]

func load_villagers(config_file: ConfigFile):
	if config_file.has_section("villagers"):
		var villagers_key = config_file.get_section_keys("villagers")
		for key in villagers_key:
			var dict: Dictionary = config_file.get_value("villagers", key)
			var villager_type: Global.villagers_type = dict["villager_type"]
			var villager_pos: Vector2 = dict["position"]
			
			var entity_to_instanciate
			match villager_type:
				Global.villagers_type.FORAGER:
					entity_to_instanciate = FORAGER
				Global.villagers_type.WOODCUTTER:
					entity_to_instanciate = LUMBERJACK
				Global.villagers_type.GOLDFINDER:
					entity_to_instanciate = GOLD_FINDER
			var instance = spawn_entity_on_pos(entity_to_instanciate, villager_pos.x, villager_pos.y)
			instance.name = key
	else:
		spawn_entity_on_pos(FORAGER, town_hall.position.x, town_hall.position.y)

func save_on_file(config_file: ConfigFile):
	save_game_resources(config_file)
	GameManager.get_save_load_manager().save_file_to_disk()

func save_on_exit():
	var config_file = GameManager.get_save_file()
	save_on_file(config_file)

func save_game_resources(config_file: ConfigFile):
	for res: Node2D in resource_parent_node.get_children(false):
		var node_id = str(res.name)
		if not res.has_node("./DamageHandler"):
			continue
		var damage_handler: DamageHandler = res.get_node("./DamageHandler")
		if res.is_in_group("Forage"):
			config_file.set_value("resources", node_id, {"position": res.position, "current_health": damage_handler.currentHealth, "resource_type": Global.resource_type.FORAGE, "forage_type": res.type})
		elif res.is_in_group("Tree"):
			config_file.set_value("resources", node_id, {"position": res.position, "current_health": damage_handler.currentHealth, "resource_type": Global.resource_type.TREE})
		elif res.is_in_group("GoldOre"):
			config_file.set_value("resources", node_id, {"position": res.position, "current_health": damage_handler.currentHealth, "resource_type": Global.resource_type.GOLDORE})



func get_goldore_list() -> Array[GoldOres]:
	goldores_list.clear()
	for n in resource_parent_node.get_children(false):
		if n.is_in_group("GoldOre"):
			goldores_list.append(n)
	return goldores_list

func get_forage_list() -> Array[Forage]:
	forage_list.clear()
	for n in resource_parent_node.get_children(false):
		if n.is_in_group("Forage"):
			forage_list.append(n)
	return forage_list

func get_tree_list() -> Array[GameTree]:
	tree_list.clear()
	#var trees_node = level_instance.get_node("./Trees")
	#tree_list = trees_node.get_children(false)
	for n in resource_parent_node.get_children(false):
		if n.is_in_group("Tree"):
			tree_list.append(n)
	return tree_list

func get_resources_list() -> Array[Node2D]:
	var array: Array[Node2D] = []
	array.append_array(get_forage_list())
	array.append_array(get_goldore_list())
	array.append_array(get_tree_list())
	return array

func get_entity_parent_node() -> Node:
	return level_instance



func remove_tree(tree: GameTree):
	if tree_list.has(tree):
		tree_list.erase(tree)

func add_tree(tree: GameTree):
	if not tree_list.has(tree):
		tree_list.append(tree)

func add_entity(entity: Node, add_child: bool = false):
	entities.append(entity)
	
	if add_child:
		resource_parent_node.add_child.call_deferred(entity)

func spawn_entity(entity) -> Node2D:
	var instance = entity.instantiate()
	level_instance.add_child.call_deferred(instance)
	entities.append(instance)
	instance.position = town_hall.position
	return instance

func spawn_entity_on_pos(entity, x: float, y: float) -> Node2D:
	var instance = entity.instantiate()
	level_instance.add_child.call_deferred(instance)
	instance.position = Vector2(int(x),int(y))
	entities.append(instance)
	return instance

func reset_entities():
	for e in level_instance.get_children(false):
		if entities.has(e):
			e.queue_free()
	
	GameManager.villagers_count = 0
	entities.clear()

func buy_villager(type: Global.villagers_type):
	if not (GameManager.villagers_count + 1 <= GameManager.max_villagers_count):
		print("not enough beds")
		return
	
	var costs: Dictionary = Global.villagers_costs.get(type)
	
	var food_new_balance = GameManager.resources[Global.resource_drop_type.FOOD] - costs[Global.resource_drop_type.FOOD]
	var wood_new_balance = GameManager.resources[Global.resource_drop_type.WOOD] - costs[Global.resource_drop_type.WOOD]
	var gold_new_balance = GameManager.resources[Global.resource_drop_type.GOLD] - costs[Global.resource_drop_type.GOLD]
	
	if food_new_balance < 0 or wood_new_balance < 0 or gold_new_balance < 0:
		print("not enough resources")
		return
	
	GameManager.resources[Global.resource_drop_type.FOOD] = food_new_balance
	GameManager.resources[Global.resource_drop_type.WOOD] = wood_new_balance
	GameManager.resources[Global.resource_drop_type.GOLD] = gold_new_balance
	
	GameManager.villagers_count += 1
	
	var entity_to_instanciate: PackedScene
	match type:
		Global.villagers_type.FORAGER:
			entity_to_instanciate = FORAGER
		Global.villagers_type.WOODCUTTER:
			entity_to_instanciate = LUMBERJACK
		Global.villagers_type.GOLDFINDER:
			entity_to_instanciate = GOLD_FINDER
	EventBus._resource_changed.emit()
	spawn_entity_on_pos(entity_to_instanciate, town_hall.position.x, town_hall.position.y)


func buy_structure(type: Global.structure_type, pos: Vector2, offset: Vector2) -> bool:
	var costs: Dictionary = Global.structure_costs.get(type)
	
	var food_new_balance = GameManager.resources[Global.resource_drop_type.FOOD] - costs[Global.resource_drop_type.FOOD]
	var wood_new_balance = GameManager.resources[Global.resource_drop_type.WOOD] - costs[Global.resource_drop_type.WOOD]
	var gold_new_balance = GameManager.resources[Global.resource_drop_type.GOLD] - costs[Global.resource_drop_type.GOLD]
	
	if food_new_balance < 0 or wood_new_balance < 0 or gold_new_balance < 0:
		print("not enough resources")
		return false;
	
	GameManager.resources[Global.resource_drop_type.FOOD] = food_new_balance
	GameManager.resources[Global.resource_drop_type.WOOD] = wood_new_balance
	GameManager.resources[Global.resource_drop_type.GOLD] = gold_new_balance
	
	var entity_to_instanciate: PackedScene
	match type:
		Global.structure_type.HOUSE:
			entity_to_instanciate = HOUSE
			GameManager.max_villagers_count += GameManager.villagers_in_house_bonus
	EventBus._resource_changed.emit()
	
	spawn_entity_on_pos(entity_to_instanciate, pos.x, pos.y)
	return true;

func can_buy_structure(type: Global.structure_type) -> bool:
	var costs: Dictionary = Global.structure_costs.get(type)
	
	var food_new_balance = GameManager.resources[Global.resource_drop_type.FOOD] - costs[Global.resource_drop_type.FOOD]
	var wood_new_balance = GameManager.resources[Global.resource_drop_type.WOOD] - costs[Global.resource_drop_type.WOOD]
	var gold_new_balance = GameManager.resources[Global.resource_drop_type.GOLD] - costs[Global.resource_drop_type.GOLD]
	
	if food_new_balance < 0 or wood_new_balance < 0 or gold_new_balance < 0:
		return false
	return true
