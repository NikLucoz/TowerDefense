extends VillagerState

var harvesting_damage: int

func enter() -> void:
	harvesting_damage = actor.damage_to_resource
	print("Start Harvesting")
	animated_sprite_2d.play("Harvesting")
	
	if not animated_sprite_2d.is_connected("animation_finished", _on_animation_finished):
		animated_sprite_2d.connect("animation_finished", _on_animation_finished)

func update(_delta: float) -> void:
	if actor.target == null:
		transition.emit("IdleState")

func _on_animation_finished():
	if not actor.target:
		transition.emit("IdleState")
		return

	var target: Forage = actor.target
	if animated_sprite_2d.animation == "Harvesting":
		if target.damage_handler.damageable or not target:
			target.damage_handler.takeDamage(harvesting_damage)
			animated_sprite_2d.play("Harvesting")
		else:
			actor.target = null
