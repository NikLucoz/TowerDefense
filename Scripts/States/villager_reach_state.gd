extends VillagerState

var closest_forage: Node2D = null
var closest_distance = INF
var is_harvesting_started = false
var fog_manager: FogManager

func enter() -> void:
	fog_manager = GameManager.get_fog_manager()
	animated_sprite_2d.play("Walking")
	is_harvesting_started = false
	closest_forage = actor.target

func update(delta: float) -> void:
	#fog_manager.update_fog(actor.position.x, actor.position.y, 600)
		
	if closest_forage != null:
		var current_position = actor.global_position
		var forage_position = Vector2(closest_forage.position.x - 30, closest_forage.position.y + 25)
		var direction: Vector2 = (forage_position - current_position).normalized()
		var distance = current_position.distance_to(forage_position)
		
		if distance > move_speed * delta:
			actor.global_position += direction * move_speed * delta
		else:
			actor.global_position = forage_position
			closest_forage = null  # Stop moving when reached
			transition.emit("WorkingState")
