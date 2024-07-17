class_name EntityManager extends Node

const FORAGER = preload("res://Scenes/Villagers/forager.tscn")
const WOOD_CUTTER = preload("res://Scenes/Villagers/wood_cutter.tscn")
const GOLD_FINDER = preload("res://Scenes/Villagers/gold_finder.tscn")

enum villagers_type {
	FORAGER,
	WOODCUTTER,
	GOLDFINDER
}

var entities: Array[Node] = []
var level_instance: Node
var level_tilemap: TileMap
var town_hall: Node2D

@export var tree_list: Array[GameTree]
@export var forage_list: Array[Forage]
@export var goldores_list: Array[GoldOres]

func _ready():
	level_instance = get_tree().root.get_node("./Level")
	level_tilemap = level_instance.get_node("./TileMap")

func get_goldore_list() -> Array[GoldOres]:
	goldores_list.clear()
	for n in level_instance.get_children(false):
		if n.is_in_group("GoldOre"):
			goldores_list.append(n)
	return goldores_list

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

func add_entity(entity: Node):
	entities.append(entity)

func spawn_entity(entity):
	var instance = entity.instantiate()
	level_instance.add_child.call_deferred(instance)
	entities.append(instance)

func spawn_entity_on_pos(entity, x: float, y: float):
	var instance = entity.instantiate()
	level_instance.add_child.call_deferred(instance)
	instance.position = Vector2(int(x),int(y))
	entities.append(instance)

func reset_entities():
	for e in level_instance.get_children(false):
		if entities.has(e):
			e.queue_free()
	
	entities.clear()

func buy_villager(type: villagers_type):
	var costs: Dictionary = GameManager.villagers_costs.get(type)
	
	var food_new_balance = GameManager.resources[GameManager.resource_type.FOOD] - costs[GameManager.resource_type.FOOD]
	var wood_new_balance = GameManager.resources[GameManager.resource_type.WOOD] - costs[GameManager.resource_type.WOOD]
	var gold_new_balance = GameManager.resources[GameManager.resource_type.GOLD] - costs[GameManager.resource_type.GOLD]
	
	if food_new_balance < 0 or wood_new_balance < 0 or gold_new_balance < 0:
		print("not enough resources")
		return
	
	GameManager.resources[GameManager.resource_type.FOOD] = food_new_balance
	GameManager.resources[GameManager.resource_type.WOOD] = wood_new_balance
	GameManager.resources[GameManager.resource_type.GOLD] = gold_new_balance
	
	var entity_to_instanciate: PackedScene
	match type:
		villagers_type.FORAGER:
			entity_to_instanciate = FORAGER
		villagers_type.WOODCUTTER:
			entity_to_instanciate = WOOD_CUTTER
		villagers_type.GOLDFINDER:
			entity_to_instanciate = GOLD_FINDER
	EventBus._resource_changed.emit()
	spawn_entity_on_pos(entity_to_instanciate, town_hall.position.x, town_hall.position.y)
