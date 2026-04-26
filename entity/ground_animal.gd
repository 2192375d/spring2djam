class_name GroundAnimal
extends SentientAnimal



#@export var state_machine : GroundStateMachine


var grav_accel : float

func _physics_process(delta: float) -> void:
	if get_parent() is not Player:
		state_machine.process_physics_frame(delta)
		if !is_on_floor():
			grav_accel += Constants.GRAVITY 
			velocity.y += grav_accel 
		else:
			grav_accel = 0
			# default domain unassigned
			if (domain_point == Vector2(0,0)): 
				domain_point = self.global_position
	if self.velocity.x < 0.0:
		animation.play("walk")
		animation.flip_h = true
	elif self.velocity.x > 0.0:
		animation.play("walk")
		animation.flip_h = false
	else:
		animation.play("idle")
	move_and_slide()

func player_movement(_delta: float) -> void:
	velocity.x = 0.0
	
	if !is_on_floor():
		velocity.y += Constants.GRAVITY
	elif Input.is_action_just_pressed("space"):
			velocity.y = -500.0
	var x_direction: float = sign(Input.get_axis("left", "right"))

	velocity.x = x_direction * speed
