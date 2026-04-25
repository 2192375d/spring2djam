extends Animal

class_name Kiwi

@export var speed: float

@export var animation: AnimatedSprite2D

var is_player: bool = true

func _ready() -> void:
	animation.play("idle")

func _physics_process(delta: float) -> void:
	if is_player:
		player_movement(delta)
	else:
		# do the ai stuffs
		pass
	
	move_and_slide()

#func player_fly_movement(_delta: float) -> void:
	#velocity = Vector2.ZERO
	#
	#var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	#velocity = direction_vector * speed

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
