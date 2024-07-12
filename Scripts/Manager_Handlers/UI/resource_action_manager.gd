extends Control

const LUMBERJACK = preload("res://Scenes/Villagers/wood_cutter.tscn")
const FORAGER = preload("res://Scenes/Villagers/forager.tscn")

@onready var wood_label = $ResourceContainer/WoodPanel/Label
@onready var gold_label = $ResourceContainer/GoldPanel/Label
@onready var food_label = $ResourceContainer/FoodPanel/Label

func _process(_delta):
	wood_label.text = str(GameManager.resources[GameManager.resource_type.WOOD])
	gold_label.text = str(GameManager.resources[GameManager.resource_type.GOLD])
	food_label.text = str(GameManager.resources[GameManager.resource_type.FOOD])

func _on_spawn_lumberJack_button_pressed():
	GameManager.spawn_entity(LUMBERJACK)

func _on_reset_entities_button_pressed():
	GameManager.reset_entities()

func _on_spawn_forager_button_2_pressed():
	GameManager.spawn_entity(FORAGER)
