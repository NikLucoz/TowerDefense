extends Node
var version_level_string: String = "v0.1"

var villagers_costs: Dictionary = { 
	Global.villagers_type.FORAGER: {
		Global.resource_drop_type.FOOD: 30,
		Global.resource_drop_type.WOOD: 0,
		Global.resource_drop_type.GOLD: 0,
	}, 
	Global.villagers_type.WOODCUTTER: {
		Global.resource_drop_type.FOOD: 50,
		Global.resource_drop_type.WOOD: 0,
		Global.resource_drop_type.GOLD: 10,
	}, 
	Global.villagers_type.GOLDFINDER: {
		Global.resource_drop_type.FOOD: 120,
		Global.resource_drop_type.WOOD: 30,
		Global.resource_drop_type.GOLD: 0,
	}
}

@onready var _entity_manager: EntityManager = $EntityManager
@onready var _date_time_manager: DateTimeManager = $DateTimeManager
@onready var _save_load_manager: SaveLoadManager = $SaveLoadManager

@export var map_size_width = 200
@export var map_size_height = 200
@export var resources = {
	Global.resource_drop_type.FOOD: 150,
	Global.resource_drop_type.GOLD: 100,
	Global.resource_drop_type.WOOD: 100
}

func _ready():
	EventBus.connect("_world_gen_finished", _on_world_gen_finished)
	EventBus.connect("_save_triggered", save_on_file)
	connect("tree_exiting", save_on_exit)
	load_save()

func _on_world_gen_finished():
	#_entity_manager.spawn_entity_on_pos(_entity_manager.FORAGER, _entity_manager.town_hall.position.x, _entity_manager.town_hall.position.y)
	EventBus.emit_signal("_trigger_entity_load")
	pass

func _unhandled_input(event):
	if event.is_action_pressed("exit"):
		_save_load_manager._reset_resources()
		get_tree().quit()


# SAVE & LOAD SECTION
func load_save():
	var config_file: ConfigFile = _save_load_manager.get_savefile()
	if config_file.has_section("player"):
		resources = config_file.get_value("player", "resources")

func save_on_file(config_file: ConfigFile):
	config_file.set_value("player", "resources", resources)
	_save_load_manager.save_file_to_disk()

func save_on_exit():
	var config_file = get_save_file()
	save_on_file(config_file)


# GETTERS
func get_entity_manager() -> EntityManager:
	return _entity_manager

func get_date_time_manager() -> DateTimeManager:
	return _date_time_manager

func get_save_load_manager() -> SaveLoadManager:
	return _save_load_manager

func get_save_file() -> ConfigFile:
	return _save_load_manager.get_savefile()

func get_tree_list():
	return _entity_manager.get_tree_list()

func get_forage_list():
	return _entity_manager.get_forage_list()

func get_goldore_list():
	return _entity_manager.get_goldore_list()

# RESOURCES FUNCTIONS
func add_resource(drop: ResourceDrop):
	resources[drop.type] += drop.amount
	print("Added 1 " + str(drop.type))

