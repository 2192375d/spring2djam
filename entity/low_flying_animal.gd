extends Animal

class_name LowFlyingAnimal

@export var speed: float

func player_movement(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction_vector * speed
