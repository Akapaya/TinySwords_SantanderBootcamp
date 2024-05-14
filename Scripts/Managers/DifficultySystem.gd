extends Node

@export var MobSpawner: MobSpawner
@export var MobsIncreasePerMinute: float = 30
@export var initialSpawnRate:float = 30
@export var WaveDuration: float = 20
@export var breakIntensity:float = 0.5

var time:float = 0.0

func _process(delta):
	time += delta
	
	var spawnRate = initialSpawnRate + MobsIncreasePerMinute * (time/60.0)
	
	var sinWave = sin((time * TAU/ WaveDuration))
	var waveFactor = remap(sinWave,-1, 1,breakIntensity, 1)
	
	spawnRate *= waveFactor
	
	MobSpawner.mobsPerMinute = spawnRate
