class_name VillagerCuttingState extends VillagerState

@export var cutting_damage = 20

func enter() -> void:
	animated_sprite_2d.play("Chopping")
	
	if not animated_sprite_2d.is_connected("animation_finished", _on_animation_finished):
		animated_sprite_2d.connect("animation_finished", _on_animation_finished)

func update(_delta: float) -> void:
	if actor.target == null:
		transition.emit("IdleState")

func _on_animation_finished():
	var target: GameTree = actor.target
	if animated_sprite_2d.animation == "Chopping":
		if not target.chopped:
			if target.get_node("DamageHandler"):
				target.get_node("DamageHandler").takeDamage(cutting_damage)
				animated_sprite_2d.play("Chopping")
		else:
			actor.target = null
