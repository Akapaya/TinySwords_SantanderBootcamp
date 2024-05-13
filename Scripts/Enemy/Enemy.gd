class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var deathFab: PackedScene

var healthManager : HealthManager

func _ready():
	healthManager = get_node("HealthManager")

func TakeDamage(damage: int) -> void:
	health = healthManager.TakeDamage(damage, health)
	DamageEffect()
	
	if health <= 0:
		DeathAnimation()

func DamageEffect() -> void:
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

func DeathAnimation() -> void:
	if deathFab:
		var deathObject = deathFab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
		
	queue_free()
