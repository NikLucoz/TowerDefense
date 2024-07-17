class_name DateTimeManager extends Node

@onready var dateTime: DateTime = DateTime.new(time)

@export var initial_year: int = 1
@export var time_multiplier: float
@export_range(1, 365) var initial_day: int = 0
@export_range(0, 23) var initial_hour: int = 6

var work_signal_emitted = false
var sleep_signal_emitted = false

var time: float

func _ready():
	time = (60 * 60 * 24 * 365 * initial_year) + (initial_day * 60 * 60 * 24) + (60 * 60 * initial_hour)

func _process(delta):
	time += delta * time_multiplier
	dateTime = DateTime.new(time)
	
	EventBus.emit_signal("_time_passed", delta * time_multiplier)
	

func get_real_time():
	var initial_second_in_a_year = 60 * 60 * 24 * 365 * initial_year
	var initial_seconds_in_a_day = initial_day * 60 * 60 * 24
	var intial_second_in_a_hour = (60 * 60 * initial_hour)
	var real_time = (time - initial_second_in_a_year - initial_seconds_in_a_day -intial_second_in_a_hour) / time_multiplier
	return real_time

func check_work_hours_for_villagers(): # WIP
	pass

func set_time(t: float):
	time = t
	dateTime = DateTime.new(time)
