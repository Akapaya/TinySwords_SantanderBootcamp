extends CharacterBody2D

#Movement Vars
@export var movementSpeed: float = 3
@export var lerpWeight: float = 0.4
@export var movementSpeedMultiply: float = 5000

#States
var isRunning : bool = false

@onready var spritePlayer: Sprite2D = %Sprite2D
@onready var animationPlayer: AnimationPlayer = %AnimationPlayer

func _physics_process(delta :float) -> void:
	var inputVector = Input.get_vector("MoveLeft","MoveRight","MoveUp","MoveDown",0.15)
	
	var targetVelocity = inputVector * movementSpeed * movementSpeedMultiply * delta
	velocity = lerp(velocity, targetVelocity, lerpWeight)
	move_and_slide()
	
	isRunning = not inputVector.is_zero_approx()
	
	if isRunning:
		animationPlayer.PlayAnimationByString("run")
	else :
		animationPlayer.PlayAnimationByString("idle")
	
	if inputVector.x < 0:
		spritePlayer.flip_h = true
	elif inputVector.x > 0:
		spritePlayer.flip_h = false
