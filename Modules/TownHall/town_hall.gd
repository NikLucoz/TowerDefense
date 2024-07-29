extends Node2D
@onready var point_light_2d = $PointLight2D

func _ready():
	var fog_manager = GameManager.get_fog_manager()
	fog_manager.update_fog(position.x, position.y, 2000)

func _on_button_pressed():
	EventBus.emit_signal("_open_close_action_panel")
