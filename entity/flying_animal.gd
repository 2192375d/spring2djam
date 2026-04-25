extends Animal

class_name FlyingAnimal

@export var speed: float
@export var animation: AnimatedSprite2D
@export var domain_radius : int
@export var domain_point : Vector2
#@export var state_machine : FlyingStateMachine
@export var vision_area : Area2D
@export var eating_area : Area2D

func _ready() -> void:
	pass

func player_movement(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction_vector * speed

func _physics_process(delta: float) -> void:
	if get_parent() is not Player:
		pass	
	move_and_slide()
