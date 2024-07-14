extends VillagerState

var mining_damage: int

func enter() -> void:
	mining_damage = actor.damage_to_resource
	animated_sprite_2d.play("Mining")
	
	if not animated_sprite_2d.is_connected("animation_finished", _on_animation_finished):
		animated_sprite_2d.connect("animation_finished", _on_animation_finished)

func update(_delta: float) -> void:
	if actor.target == null:
		transition.emit("IdleState")

func _on_animation_finished():
	var target: GoldOres = actor.target
	if animated_sprite_2d.animation == "Mining":
		if target.get_node("DamageHandler"):
			target.get_node("DamageHandler").takeDamage(mining_damage)
			animated_sprite_2d.play("Mining")
		else:
			actor.target = null

