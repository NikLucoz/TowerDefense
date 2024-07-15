extends Node
var version_level_string: String = "v0.1"

enum resource_type { WOOD, GOLD, FOOD }
enum villagers_type {
	FORAGER,
	WOODCUTTER,
	GOLDFINDER
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
		resource_type.GOLD: 10,
	}, 
	villagers_type.GOLDFINDER: {
		resource_type.FOOD: 120,
		resource_type.WOOD: 30,
		resource_type.GOLD: 0,
	}
}

@onready var _event_bus: EventBus = $EventBus
@onready var _entity_manager: EntityManager = $EntityManager
@onready var _date_time_manager: DateTimeManager = $DateTimeManager

@export var map_size_width = 200
@export var map_size_height = 200
@export var resources = {
	resource_type.FOOD: 150,
	resource_type.GOLD: 100,
	resource_type.WOOD: 100
}

func _ready():
	_event_bus.connect("_world_gen_finished", _on_world_gen_finished)

func get_event_bus() -> EventBus:
	return _event_bus

func get_entity_manager() -> EntityManager:
	return _entity_manager

func get_date_time_manager() -> DateTimeManager:
	return _date_time_manager

func _on_world_gen_finished():
	_entity_manager.spawn_entity(_entity_manager.FORAGER)

func get_tree_list():
	return _entity_manager.get_tree_list()
	
func get_forage_list():
	return _entity_manager.get_forage_list()

func get_goldore_list():
	return _entity_manager.get_goldore_list()

func add_resource(drop: ResourceDrop):
	resources[drop.type] += drop.amount
	print("Added 1 " + str(drop.type))
