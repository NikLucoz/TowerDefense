extends Node2D

@export var structure_type: Global.structure_type

func _ready():
	EventBus.connect("_save_triggered", save_on_file)
	connect("tree_exiting", save_on_exit)

func save_on_file(config_file: ConfigFile):
	var node_id = str(self.name)
	config_file.set_value("structures", node_id, {"structure_type": structure_type, "position": position})
	GameManager.get_save_load_manager().save_file_to_disk()

func save_on_exit():
	var config_file = GameManager.get_save_file()
	save_on_file(config_file)
