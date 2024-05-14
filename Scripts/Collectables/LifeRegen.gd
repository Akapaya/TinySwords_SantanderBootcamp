extends Node2D

@export var regenerationAmount: int = 10

@onready var area2D: Area2D = $Area2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		var player: Player = body
		player.HealthRegen(regenerationAmount)
		queue_free()
