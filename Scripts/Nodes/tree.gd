class_name GameTree extends Node2D
const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
@export var drop_max_amount: int = 6
@export var time_to_reset: int = 300
var chopped: bool = false
var timer: Timer

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
		var instance = RESOURCE_DROP.instantiate()
		instance.set_type(Global.resource_drop_type.WOOD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		var entity_manager: EntityManager = GameManager.get_entity_manager()
		entity_manager.add_entity(instance, true)

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
