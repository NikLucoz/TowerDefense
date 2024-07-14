extends VillagerState

var target_resource_type: res_type
var max_searching_target_number: int 

var moving_to_pos = false
var waiting_to_move = false
var random_position: Vector2
var timer: Timer

func enter() -> void:
	target_resource_type= actor.target_resource_type
	max_searching_target_number = actor.max_searching_target_number
	animated_sprite_2d.play("Idle")
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 2
	add_child(timer)
	timer.start()
	if not timer.is_connected("timeout", _on_timer_timeout):
		timer.connect("timeout", _on_timer_timeout)

func update(delta):
	if not moving_to_pos:
		random_position = Vector2(
			clampf(randf_range(actor.global_position.x - 200, actor.global_position.x + 200), -GameManager.map_size_width * 63, GameManager.map_size_width * 63),
			clampf(randf_range(actor.global_position.y - 100, actor.global_position.y + 100), -GameManager.map_size_height * 63, GameManager.map_size_height * 63),
		)
		
		moving_to_pos = true
	elif not waiting_to_move:
		animated_sprite_2d.play("Walking")
		var direction: Vector2 = (random_position - actor.global_position).normalized()
		var distance = actor.global_position.distance_squared_to(random_position)
		
		if distance > move_speed * delta:
			actor.global_position += direction * move_speed * delta
		else:
			animated_sprite_2d.play("Idle")
			waiting_to_move = true

func _on_timer_timeout():
	moving_to_pos = false
	waiting_to_move = false
	remove_child(timer)
	find_target_resources(max_searching_target_number, target_resource_type)
