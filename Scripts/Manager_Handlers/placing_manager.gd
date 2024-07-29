class_name PlacingManager extends CanvasItem

const NOT_PLACEABLE: Color = Color8(228, 0, 31, 147)
const PLACEABLE: Color = Color8(0, 157, 255, 147)

@onready var structure_placeholder: TextureRect = $TextureRect
var structure_type: Global.structure_type
var structure_offset: Vector2
var structure_dimensions: Vector2
@export var placing: bool = false

func _ready():
	EventBus.connect("_trigger_structure_placement", set_structure)

func set_structure(structure_texture: Texture, structure_type: Global.structure_type, struct_size: Vector2 = Vector2(1,1), struct_offset: Vector2 = Vector2(0,0)):
	placing = true
	structure_type = structure_type
	structure_dimensions = Vector2(struct_size.x * 64, struct_size.y * 64)
	structure_offset = struct_offset
	structure_placeholder.visible = true
	structure_placeholder.texture = structure_texture

func _process(delta):
	if placing:
		var mouse_pos: Vector2 = get_global_mouse_position()
		# Imposta la posizione della TextureRect alla posizione del mouse

		structure_placeholder.set_position(Vector2(mouse_pos.x + structure_offset.x, mouse_pos.y + structure_offset.y))

		if can_place():
			structure_placeholder.modulate = PLACEABLE
		else: 
			structure_placeholder.modulate = NOT_PLACEABLE

func _unhandled_input(event):
	if (placing and event.is_action_pressed("ui_mouse_left")):
		print("left")
		if can_place():
			place_structure()
	
	elif (placing and event.is_action_pressed("ui_mouse_right")):
		print("abort placing structure")
		placing = false
		structure_placeholder.visible = false

func can_place() -> bool:
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	if not entity_manager.can_buy_structure(structure_type):
		return false
	
	var mouse_center_pos: Vector2 = get_global_mouse_position()
	var left_bound: float = mouse_center_pos.x - structure_dimensions.x / 2
	var right_bound: float = mouse_center_pos.x + structure_dimensions.x / 2
	var top_bound: float = mouse_center_pos.y - structure_dimensions.y / 2
	var bottom_bound: float = mouse_center_pos.y + structure_dimensions.y / 2
	
	var filtered_array: Array = []
	var resources_list: Array = entity_manager.get_resources_list()
	
	for res in resources_list:
		if res is Node2D:
			var res_position: Vector2 = res.global_position
			if res_position.x >= left_bound and res_position.x <= right_bound and res_position.y >= top_bound and res_position.y <= bottom_bound:
				filtered_array.append(res)
	
	return filtered_array.size() == 0

func place_structure():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.buy_structure(structure_type, mouse_pos, structure_offset)
