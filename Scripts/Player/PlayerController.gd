extends CharacterBody2D

#Inputs
var inputVector : Vector2

#Movement Vars
@export var movementSpeed: float = 3
@export var lerpWeight: float = 0.4
@export var movementSpeedMultiply: float = 5000

#States
var isRunning : bool = false
var isAttacking : bool = false
var attackCooldown : float = 0.0

@onready var spritePlayer: Sprite2D = %Sprite2D
@onready var animationPlayer: AnimationPlayer = %AnimationPlayer

func _process(delta: float) -> void:
	ReadInputs()
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
	
	if isAttacking:
		attackCooldown -= delta
		if attackCooldown <= 0:
			isAttacking = false

func _physics_process(delta :float) -> void:
	var targetVelocity = inputVector * movementSpeed * movementSpeedMultiply * delta
	
	if isAttacking:
		targetVelocity *= 0.25
	
	velocity = lerp(velocity, targetVelocity, lerpWeight)
	move_and_slide()	
	CheckRunningState()
	FlipCharacter()

#InputMethods
func ReadInputs() -> void:
	inputVector = Input.get_vector("MoveLeft","MoveRight","MoveUp","MoveDown",0.15)

#AttackMethods
func Attack() -> void :
	if isAttacking == true:
		return
	
	isAttacking = true
	attackCooldown = 0.4
	animationPlayer.PlayAnimationByString("attackDown1")

#CheckStateMethods
func CheckRunningState() -> void:
	isRunning = not inputVector.is_zero_approx()
	
	if isAttacking == false:
		if isRunning:
			animationPlayer.PlayAnimationByString("run")
		else :
			animationPlayer.PlayAnimationByString("idle")

#VisualMethod
func FlipCharacter() -> void:
	if inputVector.x < 0:
		spritePlayer.flip_h = true
	elif inputVector.x > 0:
		spritePlayer.flip_h = false
