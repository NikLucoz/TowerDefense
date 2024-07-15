extends Control

const LUMBERJACK = preload("res://Scenes/Villagers/wood_cutter.tscn")
const FORAGER = preload("res://Scenes/Villagers/forager.tscn")

@onready var wood_label = $MarginContainer/Container/ResourceContainer/WoodPanel/Label
@onready var gold_label = $MarginContainer/Container/ResourceContainer/GoldPanel/Label
@onready var food_label = $MarginContainer/Container/ResourceContainer/FoodPanel/Label
@onready var version_label = $MarginContainer/Container/VersionLabel

@onready var debug_action_panel = $MarginContainer/Container/DebugActionPanel

func _ready():
	debug_action_panel.visible = false
	version_label.text = GameManager.version_level_string

func _unhandled_key_input(event):
	if event.is_action_pressed("debug"):
		debug_action_panel.visible = !debug_action_panel.visible

func _process(_delta):
	wood_label.text = str(GameManager.resources[GameManager.resource_type.WOOD])
	gold_label.text = str(GameManager.resources[GameManager.resource_type.GOLD])
	food_label.text = str(GameManager.resources[GameManager.resource_type.FOOD])

func _on_spawn_lumberJack_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.spawn_entity(LUMBERJACK)

func _on_reset_entities_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.reset_entities()

func _on_spawn_forager_button_2_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.spawn_entity(FORAGER)
