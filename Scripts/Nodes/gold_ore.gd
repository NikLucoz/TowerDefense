class_name GoldOres extends Node2D

@onready var damage_handler = $DamageHandler
@onready var sprite_2d = $Sprite2D
@export var drop_max_amount: int = 6
var damage_taken: int = 0

func _ready():
	EventBus.connect("_save_triggered", save_on_file)
	connect("tree_exiting", save_on_exit)

func save_on_file(config_file: ConfigFile):
	var node_id = str(self.name)
	config_file.set_value("resources", node_id, {"position": position, "resource_type": Global.resource_type.GOLDORE})
	GameManager.get_save_load_manager().save_file_to_disk()

func save_on_exit():
	var config_file = GameManager.get_save_file()
	save_on_file(config_file)



func _on_damage_handler_destroyed_override():
	spawn_drop()
	queue_free()

func _on_damage_handler_take_damage_override(damagePower):
	damage_taken += damagePower
	damage_handler.takeDamageInternal(damagePower)
	if damage_taken >= 100:
		damage_taken = 0
		spawn_drop()

func spawn_drop():
	for i in range(randi_range(1, drop_max_amount)):
		var instance = Global.RESOURCE_DROP.instantiate()
		instance.set_type(Global.resource_drop_type.GOLD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		get_parent().get_parent().add_child(instance)
		GameManager.get_entity_manager().add_entity(instance)
