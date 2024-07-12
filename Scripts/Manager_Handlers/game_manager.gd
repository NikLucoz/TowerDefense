extends Node

enum resource_type { WOOD, GOLD, FOOD }

@export var resources = {
	resource_type.FOOD: 10,
	resource_type.GOLD: 10,
	resource_type.WOOD: 10
}

@export var tree_list: Array[GameTree]
@export var forage_list: Array[Forage]
var level_instance: Node
var level_tilemap: TileMap
var entities: Array[Node] = []

func _ready():
	level_instance = get_tree().root.get_node("./Level")
	level_tilemap = level_instance.get_node("./TileMap")
	level_tilemap.connect("world_gen_finished", on_world_gen_finished)

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

func add_resource(drop: ResourceDrop):
	resources[drop.type] += drop.amount
	print("Added 1 " + str(drop.type))

func on_world_gen_finished():
	pass

func spawn_entity(entity):
	var instance = entity.instantiate()
	level_instance.add_child.call_deferred(instance)
	entities.append(instance)

func add_entity(entity: Node):
	entities.append(entity)

func reset_entities():
	for e in level_instance.get_children(false):
		if entities.has(e):
			e.queue_free()
	
	entities.clear()
