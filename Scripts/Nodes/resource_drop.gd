class_name ResourceDrop extends Area2D

@onready var sprite_2d = $Sprite2D

@export var drop_textures = {
	Global.resource_drop_type.WOOD: Global.WOOD_TEXTURE,
	Global.resource_drop_type.GOLD: Global.GOLD_TEXTURE,
	Global.resource_drop_type.FOOD: Global.FOOD_TEXTURE
}

var type: Global.resource_drop_type = Global.resource_drop_type.WOOD
var amount = 1

func _ready():
	sprite_2d.texture = drop_textures[type]

func _on_mouse_entered():
	GameManager.add_resource(self)
	queue_free()

func set_type(res_type: Global.resource_drop_type):
	type = res_type
