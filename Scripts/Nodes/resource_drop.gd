class_name ResourceDrop extends Area2D

enum resource_type { WOOD, GOLD, FOOD }

@onready var sprite_2d = $Sprite2D

@export var drop_textures = {
	resource_type.WOOD: preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/W_Idle.png"),
	resource_type.GOLD: preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/G_Idle.png"),
	resource_type.FOOD: preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/M_Idle.png")
}

var type: resource_type = resource_type.WOOD
var amount = 1

func _ready():
	sprite_2d.texture = drop_textures[type]

func _on_mouse_entered():
	GameManager.add_resource(self)
	queue_free()

func set_type(res_type: resource_type):
	type = res_type
