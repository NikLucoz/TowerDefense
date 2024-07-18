class_name ResourceVillager extends CharacterBody2D

var target: Node2D

@export var move_speed: int = 200
@export var villager_type: Global.villagers_type
@export var target_resource_type: Global.resource_type
@export var max_searching_target_number: int = 3
@export var damage_to_resource: int = 3

func _ready():
	EventBus.connect("_save_triggered", save_on_file)
	connect("tree_exiting", save_on_exit)

func save_on_file(config_file: ConfigFile):
	var node_id = str(self.name)
	config_file.set_value("villagers", node_id, {"position": position, "villager_type": villager_type})
	GameManager.get_save_load_manager().save_file_to_disk()

func save_on_exit():
	var config_file = GameManager.get_save_file()
	save_on_file(config_file)
