extends Node
const FORAGER = preload("res://Scenes/Villagers/forager.tscn")
const WOOD_CUTTER = preload("res://Scenes/Villagers/wood_cutter.tscn")

enum resource_type { WOOD, GOLD, FOOD }
enum villagers_type {
	FORAGER,
	WOODCUTTER
}

var villagers_costs: Dictionary = { 
	villagers_type.FORAGER: {
		resource_type.FOOD: 30,
		resource_type.WOOD: 0,
		resource_type.GOLD: 0,
	}, 
	villagers_type.WOODCUTTER: {
		resource_type.FOOD: 50,
		resource_type.WOOD: 0,
		resource_type.GOLD: 0,
	}, 
}

@export var tree_list: Array[GameTree]
@export var forage_list: Array[Forage]
@export var resources = {
	resource_type.FOOD: 100,
	resource_type.GOLD: 100,
	resource_type.WOOD: 100
}

var level_instance: Node
var level_tilemap: TileMap
var entities: Array[Node] = []
var town_hall: Node2D
var in_game_ui: Control

func _ready():
	level_instance = get_tree().root.get_node("./Level")
	level_tilemap = level_instance.get_node("./TileMap")
	level_tilemap.connect("world_gen_finished", _on_world_gen_finished)

func get_forage_list() -> Array[Forage]:
	forage_list.clear()
	for n in level_instance.get_children(false):
		if n.is_in_group("Forage"):
			forage_list.append(n)
	return forage_list

func get_tree_list() -> Array[GameTree]:
	tree_list.clear()
	#var trees_node = level_instance.get_node("./Trees")
	#tree_list = trees_node.get_children(false)
	for n in level_instance.get_children(false):
		if n.is_in_group("Tree"):
			tree_list.append(n)
	return tree_list

func remove_tree(tree: GameTree):
	if tree_list.has(tree):
		tree_list.erase(tree)

func add_tree(tree: GameTree):
	if not tree_list.has(tree):
		tree_list.append(tree)

func add_resource(drop: ResourceDrop):
	resources[drop.type] += drop.amount
	print("Added 1 " + str(drop.type))

func _on_world_gen_finished():
	spawn_entity(FORAGER)

func add_entity(entity: Node):
	entities.append(entity)

func spawn_entity(entity):
	var instance = entity.instantiate()
	instance.position = Vector2(town_hall.global_position.x + 3, town_hall.global_position.y + 20)
	level_instance.add_child.call_deferred(instance)
	entities.append(instance)

func buy_villager(type: villagers_type):
	var costs: Dictionary = villagers_costs.get(type)
	var food_new_balance = resources[resource_type.FOOD] - costs[resource_type.FOOD]
	var wood_new_balance = resources[resource_type.WOOD] - costs[resource_type.WOOD]
	var gold_new_balance = resources[resource_type.GOLD] - costs[resource_type.GOLD]
	
	if food_new_balance < 0 or wood_new_balance < 0 or gold_new_balance < 0:
		return
	
	resources[resource_type.FOOD] = food_new_balance
	resources[resource_type.WOOD] = wood_new_balance
	resources[resource_type.GOLD] = gold_new_balance
	
	var entity_to_instanciate: PackedScene
	match type:
		villagers_type.FORAGER:
			entity_to_instanciate = FORAGER
		villagers_type.WOODCUTTER:
			entity_to_instanciate = WOOD_CUTTER
	spawn_entity(entity_to_instanciate)

func reset_entities():
	for e in level_instance.get_children(false):
		if entities.has(e):
			e.queue_free()
	
	entities.clear()

func openCloseActionPanel():
	in_game_ui.open_close_action_panel()
