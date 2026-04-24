extends CharacterBody2D
@export var speed: float

func _physics_process(_delta: float) -> void:
	
	#velocity.y += Constants.GRAVITY * delta
	
	velocity = Vector2.ZERO
	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()
