class_name GameTree extends Node2D

const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var drop_max_amount: int = 6
var chopped: bool = false

func _on_damage_handler_destroyed_override():
	print("tree chopped")
	
	chopped = true
	animated_sprite_2d.play("FullChopped")
	GameManager.remove_tree(self)
	
	for i in range(randi_range(1, drop_max_amount)):
		var instance = RESOURCE_DROP.instantiate()
		instance.set_type(instance.resource_type.WOOD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		get_parent().get_parent().add_child(instance)
		GameManager.add_entity(instance)
