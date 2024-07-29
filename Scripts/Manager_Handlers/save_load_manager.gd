class_name SaveLoadManager extends Node

var encrypt_save_file: bool = false
var encrypt_password: String = "un2IAd9ShlecsmvQZVdJsnxya2Abmft3"
var savefile_number: int = 1
var save_path:String = "user://"
var curret_game_file: ConfigFile

var timer: Timer
var exit_game_after: bool = false

func _ready():
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 300
	add_child(timer)
	timer.connect("timeout", trigger_Save)

func get_savefile() -> ConfigFile:
	if curret_game_file:
		return curret_game_file
		
	curret_game_file = ConfigFile.new()
	if encrypt_save_file:
		if curret_game_file.load_encrypted_pass(save_path + "sf_"+ str(savefile_number) +".ini", encrypt_password) != OK:
			print("Config loading error")
	else:
		if curret_game_file.load(save_path + "sf_"+ str(savefile_number) +".ini") != OK:
			print("Config loading error")
	return curret_game_file

func change_save_file_number(num: int) -> bool:
	if num <= 0 || num > 3:
		return false
	
	savefile_number = num
	return true

func _reset_resources():
	var config_file: ConfigFile = get_savefile()
	if config_file.has_section("resources"):
		config_file.erase_section("resources")

func _reset_villagers():
	var config_file: ConfigFile = get_savefile()
	if config_file.has_section("villagers"):
		print("villager erased")
		config_file.erase_section("villagers")

func trigger_Save():
	print("save triggered")
	_reset_resources()
	EventBus.emit_signal("_save_triggered", get_savefile())

func save_and_quit():
	_reset_villagers()
	_reset_resources()
	get_tree().quit()

func save_file_to_disk():
	var save_file = get_savefile()
	if encrypt_save_file:
		if save_file.save_encrypted_pass(save_path + "sf_"+ str(savefile_number) +".ini", encrypt_password) != OK:
			print("Config save error")
	else:
		save_file.save(save_path + "sf_"+ str(savefile_number) +".ini")
