class_name Forage extends Node2D
const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")

@onready var damage_handler = $DamageHandler
@onready var sprite_2d = $Sprite2D
@onready var timer: Timer = $Timer

@export var drop_mushroom_max_amount: int = 2
@export var drop_berry_max_amount: int = 2
@export var berry_reset_seconds: int = 120
@export var type: Global.forage_type

func _ready():
	if type == Global.forage_type.BERRY:
		sprite_2d.texture = Global.BERRY_BUSH
		timer.wait_time = berry_reset_seconds
	else:
		sprite_2d.texture = Global.MUSHROOM

func _on_damage_handler_destroyed_override():
	if type == Global.forage_type.MUSHROOM:
		spawn_drop(drop_mushroom_max_amount)
		queue_free()
	if type == Global.forage_type.BERRY:
		timer.start()
		damage_handler.damageable = false
		spawn_drop(drop_berry_max_amount)
		sprite_2d.texture = Global.NO_BERRY_BUSH

func spawn_drop(max_amount):
	for i in range(randi_range(1, max_amount)):
		var res = RESOURCE_DROP
		var instance = res.instantiate()
		instance.set_type(Global.resource_drop_type.FOOD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		var entity_manager: EntityManager = GameManager.get_entity_manager()
		entity_manager.add_entity(instance, true)

func _on_timer_timeout():
	damage_handler.reset_to_full_health()
	damage_handler.damageable = true
	sprite_2d.texture = Global.BERRY_BUSH
