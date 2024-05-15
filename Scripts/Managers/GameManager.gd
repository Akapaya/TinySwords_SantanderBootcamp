extends Node

var playerPosition: Vector2
var Kills: int
var Gold: int
var timeElapsed: float = 0.0
var isGameOver: bool = false

signal OnGameOver

func EndGame():
	if isGameOver:
		return
	
	isGameOver = true
	OnGameOver.emit()

func Reset():
	Kills = 0
	Gold = 0
	playerPosition = Vector2.ZERO
	timeElapsed = 0
	isGameOver = false
	for connection in OnGameOver.get_connections():
		OnGameOver.disconnect(connection.callable)
