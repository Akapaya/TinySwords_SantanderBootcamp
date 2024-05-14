class_name Player
extends CharacterBody2D

#Inputs
var inputVector : Vector2

#Movement Vars
@export var movementSpeed: float = 3
@export var lerpWeight: float = 0.4
@export var movementSpeedMultiply: float = 5000

#Stats Vars
@export var Strenght: int = 2
@export var maxHealth: int = 50
@export var health: int = 50

#Fabs Vars
@export var deathFab: PackedScene

#States
var isRunning : bool = false
var isAttacking : bool = false
var attackCooldown : float = 0.0
var hitBoxCooldown : float = 0.0

@onready var swordArea: Area2D = %SwordArea
@onready var ContactZone : Area2D = %ContactZone
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
	
	if isAttacking == false:
		FlipCharacter()
	
	CheckContactEnemies(delta)
	
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

#TakeDamage Methods
func CheckContactEnemies(delta : float) -> void:
	hitBoxCooldown -= delta
	if hitBoxCooldown > 0:
		return
	
	hitBoxCooldown = 0.5
	
	var bodies = ContactZone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemies"):
			var enemy : Enemy = body
			var damage = 1
			TakeDamage(damage)

func TakeDamage(damage: int) -> void:
	if(health <= 0):
		return
	
	health -= damage
	DamageEffect()
	
	if health <= 0:
		DeathAnimation()

func DamageEffect() -> void:
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

func DeathAnimation() -> void:
	if deathFab:
		var deathObject = deathFab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
		
	queue_free()

func HealthRegen(amount : float) ->void:
	health +=amount
	if(health >= maxHealth):
		health = maxHealth
