extends Node2D

var character : CharacterBody2D
var sprite : AnimatedSprite2D

@export var movementSpeed : float = 100.0
@export var multiplySpeed : float = 100.0
var inputVector : Vector2

func _ready():
	character = get_parent()
	sprite = character.get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
	inputVector = (GameManager.playerPosition - character.position).normalized()
	
	character.velocity =  (inputVector * movementSpeed * multiplySpeed) * delta
	character.move_and_slide()
	FlipCharacter()


#VisualMethod
func FlipCharacter() -> void:
	if inputVector.x < 0:
		sprite.flip_h = true
	elif inputVector.x > 0:
		sprite.flip_h = false
