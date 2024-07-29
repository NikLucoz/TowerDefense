extends Control

const FORAGER = preload("res://Scenes/Villagers/forager.tscn")
const GOLD_FINDER = preload("res://Scenes/Villagers/gold_finder.tscn")
const LUMBERJACK = preload("res://Scenes/Villagers/wood_cutter.tscn")
@onready var wood_label = $MarginContainer/Container/ResourceContainer/WoodPanel/Label
@onready var gold_label = $MarginContainer/Container/ResourceContainer/GoldPanel/Label
@onready var food_label = $MarginContainer/Container/ResourceContainer/FoodPanel/Label
@onready var villagers_label = $MarginContainer/Container/ResourceContainer/VillagersPanel/Label
@onready var version_label = $MarginContainer/Container/VersionLabel
@onready var time_date_label = $TimeDateLabel
@onready var debug_action_panel = $MarginContainer/Container/DebugActionPanel

func _ready():
	debug_action_panel.visible = false
	version_label.text = GameManager.version_level_string
	EventBus.connect("_time_passed", update_time_date)

func _unhandled_key_input(event):
	if event.is_action_pressed("debug"):
		debug_action_panel.visible = !debug_action_panel.visible

func update_time_date(_time_passed):
	time_date_label.text = GameManager.get_date_time_manager().dateTime._to_string()

func _process(_delta):
	wood_label.text = str(GameManager.resources[Global.resource_drop_type.WOOD])
	gold_label.text = str(GameManager.resources[Global.resource_drop_type.GOLD])
	food_label.text = str(GameManager.resources[Global.resource_drop_type.FOOD])
	villagers_label.text = str(GameManager.villagers_count) + "/" + str(GameManager.max_villagers_count)

func _on_spawn_lumberJack_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.spawn_entity(LUMBERJACK)

func _on_reset_entities_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.reset_entities()

func _on_spawn_forager_button_2_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.spawn_entity(FORAGER)

func _on_spawn_gold_finder_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.spawn_entity(GOLD_FINDER)

func _on_add_resources_button_pressed():
	GameManager.resources[Global.resource_drop_type.WOOD] += 10
	GameManager.resources[Global.resource_drop_type.GOLD] += 10
	GameManager.resources[Global.resource_drop_type.FOOD] += 10

func _on_remove_resources_button_pressed():
	GameManager.resources[Global.resource_drop_type.WOOD] -= 10
	GameManager.resources[Global.resource_drop_type.GOLD] -= 10
	GameManager.resources[Global.resource_drop_type.FOOD] -= 10


func _on_fast_forward_button_pressed():
	GameManager.change_engine_time(4)

func _on_normal_button_pressed():
	GameManager.change_engine_time(1)
