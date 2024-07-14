class_name Forage extends Node2D
const BERRY_BUSH = preload("res://Assets/Resources/Forages/berry_bush.png")
const NO_BERRY_BUSH = preload("res://Assets/Resources/Forages/no_berry_bush.png")
const MUSHROOM = preload("res://Assets/Resources/Forages/mushrooms.png")
const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")
enum forage_type {BERRY, MUSHROOM}

@onready var damage_handler = $DamageHandler
@onready var sprite_2d = $Sprite2D
@onready var timer: Timer = $Timer

@export var drop_mushroom_max_amount: int = 2
@export var drop_berry_max_amount: int = 2
@export var berry_reset_seconds: int = 120
@export var type: forage_type

func _ready():
	if type == forage_type.BERRY:
		sprite_2d.texture = BERRY_BUSH
		timer.wait_time = berry_reset_seconds
	else:
		sprite_2d.texture = MUSHROOM

func _on_damage_handler_destroyed_override():
	if type == forage_type.MUSHROOM:
		spawn_drop(drop_mushroom_max_amount)
		queue_free()
	if type == forage_type.BERRY:
		timer.start()
		damage_handler.damageable = false
		spawn_drop(drop_berry_max_amount)
		sprite_2d.texture = NO_BERRY_BUSH

func spawn_drop(max_amount):
	for i in range(randi_range(1, max_amount)):
			var instance = RESOURCE_DROP.instantiate()
			instance.set_type(instance.resource_type.FOOD)
			var drop_position = Vector2(
				randf_range(-70, 70),
				randf_range(-70, 70)
			)
			instance.position = global_position + drop_position
			get_parent().get_parent().add_child(instance)
			GameManager.add_entity(instance)

func _on_timer_timeout():
	damage_handler.reset_to_full_health()
	damage_handler.damageable = true
	sprite_2d.texture = BERRY_BUSH
