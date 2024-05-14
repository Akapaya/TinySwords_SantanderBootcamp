extends Node2D

@export var damage: int = 1
@onready var area2D: Area2D = $Area2D

func dealDamage() -> void:
	var bodies = area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemies"):
			var enemy: Enemy = body
			enemy.TakeDamage(damage)
