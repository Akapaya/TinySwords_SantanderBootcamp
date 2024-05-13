class_name HealthManager
extends Node2D

func TakeDamage(damage: int, health: int) -> int:
	health -= damage
	return health
