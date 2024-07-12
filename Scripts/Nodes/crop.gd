extends Node2D

const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var damage_handler = $DamageHandler
@onready var timer = $Timer

@export var drop_max_amount: int = 6
@export var max_stages: int = 3
@export var seconds_between_stage: int = 15
@export var sprite_frames: SpriteFrames
var stage: int = 0
	
func _ready():
	animated_sprite_2d.sprite_frames = sprite_frames
	animated_sprite_2d.frame = 0
	damage_handler.damageable = false
	timer.wait_time = seconds_between_stage
	timer.start()

func _on_timer_timeout():
	print("lettuceTimeout")
	if stage + 1 < max_stages:
		stage += 1
	else:
		damage_handler.destroyedInternal()
	
	timer.start()
	animated_sprite_2d.frame = stage

func _on_damage_handler_destroyed_override():
	for i in range(randi_range(1, drop_max_amount)):
		var instance = RESOURCE_DROP.instantiate()
		instance.set_type(instance.resource_type.FOOD)
		var drop_position = Vector2(
			randf_range(-70, 70),
			randf_range(-70, 70)
		)
		instance.position = global_position + drop_position
		get_parent().get_parent().add_child(instance)
		GameManager.add_entity(instance)
	queue_free()
