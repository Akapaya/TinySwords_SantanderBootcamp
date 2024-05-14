extends Node2D

@onready var pathFollow2D : PathFollow2D = %PathFollow2D
@export var creatures: Array[PackedScene]
@export var mobsPerMinute: float = 60.0

var cooldown: float = 0.0

func _process(delta):
	cooldown -= delta
	if cooldown > 0:
		return
	
	var interval = 60.0 / mobsPerMinute
	cooldown = interval
	
	var index = randi_range(0, creatures.size() -1)
	var creature_scene = creatures[index]
	var point = GetPoint()
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)

func GetPoint() -> Vector2:
	pathFollow2D.progress_ratio = randf()
	return pathFollow2D.global_position
