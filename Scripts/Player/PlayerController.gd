extends CharacterBody2D

#Inputs
var inputVector : Vector2

#Movement Vars
@export var movementSpeed: float = 3
@export var lerpWeight: float = 0.4
@export var movementSpeedMultiply: float = 5000

#Stats Vars
@export var Strenght: int = 2

#States
var isRunning : bool = false
var isAttacking : bool = false
var attackCooldown : float = 0.0

@onready var swordArea: Area2D = %SwordArea
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
	
	GameManager.playerPosition = position

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

func CheckEnemiesAttacked() -> void:
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemies"):
			var enemy : Enemy = body
			var directionToEnemy = (enemy.position - position).normalized()
			var attackDirection : Vector2
			
			if spritePlayer.flip_h:
				attackDirection = Vector2.LEFT
			else:
				attackDirection = Vector2.RIGHT
			
			var dotProduct = directionToEnemy.dot(attackDirection)
			
			if dotProduct >= 0.3:
				enemy.TakeDamage(Strenght)

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
