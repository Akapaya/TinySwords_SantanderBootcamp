extends CanvasLayer

@onready var timerLabel: Label = %TimerLabel
@onready var goldLabel: Label = %GoldLabel
@onready var killLabel: Label = %KillLabel

var timeElapsed: float = 0.0

func _process(delta):
	timeElapsed += delta
	var timeElapsedInSeconds: int = floori(timeElapsed)
	var seconds: int = timeElapsedInSeconds % 60
	var minutes: int = timeElapsedInSeconds / 60
	
	timerLabel.text = "%02d:%02d" %[minutes, seconds]
	
	killLabel.text = str(GameManager.Kills)
	goldLabel.text = str(GameManager.Gold)
