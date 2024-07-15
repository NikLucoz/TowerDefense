extends Node

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@export var gradient: GradientTexture1D
var date_time_manager: DateTimeManager

func _process(_delta):
	if not date_time_manager:
		date_time_manager = GameManager.get_date_time_manager()
		
	var minute_passed: float = (floori(date_time_manager.time / 60) % 1440)
	var normalized_time = minute_passed / 1440
	canvas_modulate.color = gradient.gradient.sample(normalized_time)
