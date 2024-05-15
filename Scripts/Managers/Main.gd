extends Node2D

@export var gameUI: CanvasLayer
@export var gameOver: PackedScene

func _ready():
	GameManager.OnGameOver.connect(TriggerGameOver)

func TriggerGameOver():
	if gameUI:
		gameUI.queue_free()
		gameUI = null
	
	var gameOverUI = gameOver.instantiate()
	add_child((gameOverUI))
	
