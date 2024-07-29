class_name DamageHandler extends Node

signal takeDamageOverride(damagePower: float)
signal destroyedOverride()

var currentHealth: float
var damageable: bool = true

@export var hasDamageOverride: bool = false
@export var hasDestroyedOverride: bool = false
@export var damageableStats: DamageableStats

func _ready():
	currentHealth = damageableStats.startingHealth

func takeDamage(damageAmount: float):
	if hasDamageOverride:
		takeDamageOverride.emit(damageAmount)
		return
	takeDamageInternal(damageAmount)

func takeDamageInternal(damageAmount: float):
	if not damageable:
		return
	
	var actualDamage: float = damageAmount - damageableStats.defense

	if actualDamage <= 0:
		return
	
	currentHealth -= actualDamage
	if currentHealth <= 0:
		if hasDestroyedOverride:
			destroyedOverride.emit()
			return
		destroyedInternal()

func destroyedInternal():
	if hasDestroyedOverride:
		destroyedOverride.emit()
		return
	queue_free()

func reset_to_full_health():
	currentHealth = damageableStats.startingHealth

func set_current_health(new_health):
	if new_health <= 0:
		return
	
	currentHealth = new_health
