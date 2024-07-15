class_name DateTime extends RefCounted

var time:float

var second:int
var minute:int
var hour:int
var day:int
var year:int

@warning_ignore("shadowed_variable")
func _init(time):
	self.time = time
	var int_time = int(floor(time)) # time is a decimal so we'll round it.

	second = int_time % 60
	@warning_ignore("integer_division")
	minute = (int_time / 60) % 60
	@warning_ignore("integer_division")
	hour = (int_time / (60 * 60)) % 24
	@warning_ignore("integer_division")
	day = 1 + ((int_time / (60 * 60 * 24)) % 365)
	@warning_ignore("integer_division")
	year = (int_time / (60 * 60 * 24 * 365))

@warning_ignore("shadowed_variable")
func equals(second, minute, hour, day) -> bool:
	return self.second == second and self.minute == minute and self.hour == hour and self.day == day

func _to_string(withSeconds: bool = false) -> String:
	@warning_ignore("shadowed_variable")
	var hour = self.hour
	@warning_ignore("shadowed_variable")
	var minute = self.minute
	@warning_ignore("shadowed_variable")
	var second = self.second
	
	if hour < 10:
		hour = "0" + str(hour)
	if minute < 10:
		minute = "0" + str(minute)
	if second < 10:
		second = "0" + str(second)
	
	var string = "Year " + str(year) + ", Day " + str(day) + " at " + str(hour) + ":" + str(minute)
	if withSeconds:
		string += ":" + str(second)
	
	return string
