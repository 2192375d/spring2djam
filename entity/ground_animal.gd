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


func _ready() -> void:
	animation.play("idle")
	# connect signals
	vision_area.area_entered.connect(_on_vision_area_entered)
	eating_area.area_entered.connect(_on_eating_area_body_entered)

func _on_vision_area_entered(body: Node2D) -> void:
	# check predator or prey
	if body is Animal:
		if body.entity_resource.hierarchy <= entity_resource.hierarchy: # TODO: CHANGE THIS IF THIS CAUSES BUGS
			preylist.push_back(body)
		elif body.entity_resource.hierarchy > entity_resource.hierarchy:
			predatorlist.push_back(body)
	

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

func _on_eating_area_body_entered(body: Node2D) -> void:
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			if get_parent() is Player:
				var player: Player = get_parent() as Player
				player.eat(body.entity_resource.exp_gain, body.entity_resource.hunger_gain)
			body.die()
