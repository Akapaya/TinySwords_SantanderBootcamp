class_name Enemy
extends Node

@export var health: int = 10

var healthManager : HealthManager

func _ready():
	healthManager = get_node("HealthManager")

func TakeDamage(damage: int) -> void:
	health = healthManager.TakeDamage(damage, health)
	print(health)
