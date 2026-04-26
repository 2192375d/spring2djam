extends Animal

func player_movement(_delta: float) -> void:
	return

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("idle")
	velocity.y += Constants.GRAVITY * delta
	move_and_slide()
