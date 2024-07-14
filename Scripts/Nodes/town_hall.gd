extends Node2D

signal _open_action_menu

func _on_button_pressed():
	_open_action_menu.emit()
