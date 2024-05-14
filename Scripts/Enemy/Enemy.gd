class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var deathFab: PackedScene

var damageDigitFab: PackedScene
var damageDigitMarker: Marker2D

var healthManager : HealthManager

@export var dropChance: float = 0.1
@export var dropItemsFab: Array[PackedScene]
@export var dropChances: Array[float]

func _ready():
	healthManager = get_node("HealthManager")
	damageDigitFab = preload("res://Animations/DamageDigit.tscn")
	damageDigitMarker = $DamageDigitMarker

func TakeDamage(damage: int) -> void:
	health = healthManager.TakeDamage(damage, health)
	DamageEffect()
		
	var damageDigit = damageDigitFab.instantiate()
	damageDigit.value = damage
	if damageDigitMarker:
		damageDigit.global_position = damageDigitMarker.global_position
	else:
		damageDigit.global_position = global_position
	
	get_parent().add_child(damageDigit)
	
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
		GameManager.Kills += 1
		GameManager.Gold += 10
	
	DropItem()
	
	queue_free()

func DropItem() -> void:
	var template = GetRandomDropItem().instantiate()
	template.position = position
	get_parent().get_parent().add_child(template)

func GetRandomDropItem() -> PackedScene:
	if  dropItemsFab.size() == 1:
		return dropItemsFab[0]
	
	if randf() <= dropChance:
		var maxChance : float = 0.0
		for chance in dropChances:
			maxChance += chance
		var randomValue = randf() * maxChance
		
		var needle: float = 0.0
		for i in dropItemsFab.size():
			var dropItem = dropItemsFab[i]
			var dropItemChance = dropChances[i] if i < dropChances.size() else 1
			if randomValue <= dropItemChance + needle:
				return dropItem
			needle += dropItemChance
	
	return dropItemsFab[0]
