extends Animal

class_name GroundAnimal

@export var speed: float
@export var animation: AnimatedSprite2D
@export var domain_radius : int
@export var domain_point : Vector2
@export var state_machine : GroundStateMachine
@export var vision_area : Area2D
@export var eating_area : Area2D

var preylist : Array 
var predatorlist : Array 
var grav_accel : float

func _ready() -> void:
	print("SELF:", self)
	animation.play("idle")
	
	if (!eating_area):
		push_error("no eating area for", self)
	eating_area.body_entered.connect(_on_eating_area_body_entered)
	
	# AI specific configurations
	if get_parent() is not Player:
		if (!vision_area):
			push_error("no vision area for", self)
		vision_area.body_entered.connect(_on_vision_body_entered)
		vision_area.body_exited.connect(_on_vision_body_exited)

		if (!domain_radius):
			domain_radius = Constants.CONSTANT_DOMAIN_RADIUS
		if (!state_machine):
			push_error("no state machine for", self)
		self.state_machine.setup()

func _on_vision_body_entered(body: Node2D) -> void:
	# check predator or prey
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			preylist.push_back(body)
		elif body.entity_resource.hierarchy > entity_resource.hierarchy:
			predatorlist.push_back(body)
	
func _on_vision_body_exited(body: Node2D) -> void:
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			# remove the corresponding body
			if (body in preylist):
				preylist.remove_at(preylist.find(body))
		elif body.entity_resource.hierarchy > entity_resource.hierarchy:
			if (body in predatorlist):
				predatorlist.remove_at(predatorlist.find(body))
			

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
	

func _on_eating_area_body_entered(body: Node2D) -> void:
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			if get_parent() is Player:
				var player: Player = get_parent() as Player
				player.eat(body.entity_resource.exp_gain, body.entity_resource.hunger_gain)
			body.die()
