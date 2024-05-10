class_name HealthManager
extends Node



func TakeDamage(damage: int, health: int) -> int:
	health -= damage
	return health
