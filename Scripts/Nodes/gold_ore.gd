class_name GoldOres extends Node2D

const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")

@onready var damage_handler = $DamageHandler
@onready var sprite_2d = $Sprite2D
@export var drop_max_amount: int = 6
var damage_taken: int = 0

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
		var instance = RESOURCE_DROP.instantiate()
		instance.set_type(instance.resource_type.GOLD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		get_parent().get_parent().add_child(instance)
		GameManager.add_entity(instance)
