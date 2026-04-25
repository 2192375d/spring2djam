extends Animal

class_name GroundAnimal

@export var speed: float
@export var animation: AnimatedSprite2D

func _ready() -> void:
	animation.play("idle")

func _physics_process(delta: float) -> void:
	if get_parent() is not Player:
		if !is_on_floor():
			velocity.y += Constants.GRAVITY * delta
	
	move_and_slide()

func player_movement(_delta: float) -> void:
	velocity.x = 0.0
	
	if !is_on_floor():
		velocity.y += Constants.GRAVITY
	elif Input.is_action_just_pressed("space"):
			velocity.y = -500.0
	
	var x_direction: float = sign(Input.get_axis("left", "right"))
	if x_direction < 0.0:
		animation.play("walk")
		animation.flip_h = true
	elif x_direction > 0.0:
		animation.play("walk")
		animation.flip_h = false
	else:
		animation.play("idle")
	
	velocity.x = x_direction * speed
