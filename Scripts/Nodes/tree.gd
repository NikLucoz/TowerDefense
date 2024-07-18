class_name GameTree extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var drop_max_amount: int = 6
@export var time_to_reset: int = 300
var chopped: bool = false
var timer: Timer


func _ready():
	EventBus.connect("_save_triggered", save_on_file)
	connect("tree_exiting", save_on_exit)

# SAVE SECTION
func save_on_file(config_file: ConfigFile):
	var node_id = str(self.name)
	config_file.set_value("resources", node_id, {"position": position, "resource_type": Global.resource_type.TREE})
	GameManager.get_save_load_manager().save_file_to_disk()

func save_on_exit():
	var config_file = GameManager.get_save_file()
	save_on_file(config_file)


func _on_damage_handler_destroyed_override():
	chopped = true
	animated_sprite_2d.play("FullChopped")
	GameManager.get_entity_manager().remove_tree(self)
	
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time_to_reset
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start()
	
	for i in range(randi_range(1, drop_max_amount)):
		var instance = Global.RESOURCE_DROP.instantiate()
		instance.set_type(Global.resource_drop_type.WOOD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		get_parent().get_parent().add_child(instance)
		GameManager.get_entity_manager().add_entity(instance)

func _on_timer_timeout():
	print("timer tree")
	var rng_value = randi_range(1, 100)
	if rng_value < 10:
		print("respawn tree")
		chopped = false
		animated_sprite_2d.play("default")
		GameManager.get_entity_manager().add_tree(self)
		remove_child(timer)
	else:
		queue_free()
