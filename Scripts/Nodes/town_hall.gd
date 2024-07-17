extends Node2D

func _on_button_pressed():
	EventBus.emit_signal("_open_close_action_panel")
