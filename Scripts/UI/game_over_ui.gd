extends CanvasLayer

@onready var TimeLabel : Label = %TimeLabel
@onready var MonsterLabel : Label = %MonsterLabel

var restartCooldown: float
@export var restartDelay: float = 5.0

func _ready():
	var segs: float = int(GameManager.timeElapsed) % 60
	var min: float = GameManager.timeElapsed / 60
	TimeLabel.text = "%02d:%02d" % [min, segs]
	
	MonsterLabel.text = str(GameManager.Kills)
	restartCooldown = restartDelay

func  _process(delta):
	restartCooldown -= delta
	
	if restartCooldown <= 0.0:
		RestartGame()

func RestartGame():
	GameManager.Reset()
	get_tree().reload_current_scene()
