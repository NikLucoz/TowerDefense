extends Node2D

func _on_button_pressed():
	GameManager.get_event_bus().emit_signal("_open_close_action_panel")
