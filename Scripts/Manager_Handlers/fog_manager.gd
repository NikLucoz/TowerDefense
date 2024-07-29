class_name FogManager extends Node

@onready var fog_sprite2d: Sprite2D = $FogTexture
@export var light_texture: CompressedTexture2D
@export var fog_width: int = 100
@export var fog_height: int = 100
@export var light_width: int = 600
@export var light_height: int = 600
@export var fog_enabled: bool = true

var fog_image: Image
var fog_texture: ImageTexture
var light_image: Image
var light_offset: Vector2
var light_rect: Rect2

func _ready():
	EventBus.connect("_world_gen_finished", _init_fog)

func _init_fog():
	if not fog_enabled:
		return
  # create black canvas (fog)
	fog_image = Image.create((Global.map_size_width) * 64, (Global.map_size_height) * 64, false, Image.FORMAT_RGBA8)
	fog_image.fill(Color.BLACK)
	fog_texture = ImageTexture.create_from_image(fog_image)
	fog_sprite2d.position = Vector2((Global.map_size_width) * 32, (Global.map_size_height) * 32)
	fog_sprite2d.texture = fog_texture


func update_fog(x: int, y: int, light_wh: int = 600) -> void:
	if not fog_enabled:
		return
		
	var pos: Vector2 = Vector2(x, y)
	
	# get Image from CompressedTexture2D and resize it
	light_image = light_texture.get_image()
	light_image.resize(light_wh, light_wh)

	# get center
	light_offset = Vector2(light_wh / 2, light_wh / 2)

	# get Rect2 from our Image to use it with .blend_rect() later
	light_rect = Rect2(Vector2.ZERO, light_image.get_size())
	
	fog_image.blend_rect(light_image, light_rect, pos - light_offset)
	fog_texture.update(fog_image)

func check_if_in_fog(x: int, y: int) -> bool:
	if not fog_enabled:
		return false
		
	if fog_image.get_pixel(x, y) == Color.BLACK:
		return true
	return false
