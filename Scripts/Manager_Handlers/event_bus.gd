extends Node

signal _resource_changed
signal _open_close_action_panel

signal _world_gen_finished

signal _time_passed(date_times)
signal _work_hour_finished
signal _work_hour_started

signal _save_triggered(config_file)
signal _trigger_load
signal _node_started_saving(node_reference)
signal _node_finished_saving(node_reference)

signal _trigger_structure_placement(structure_texture: Texture, structure_to_place: PackedScene, strucure_height: int, strucure_width: int)
