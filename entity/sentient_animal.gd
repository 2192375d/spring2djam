@abstract class_name SentientAnimal
extends Animal

@export var speed: float
@export var animation: AnimatedSprite2D
@export var domain_radius : int
@export var domain_point : Vector2
@export var state_machine : Node
@export var vision_area : Area2D
@export var eating_area : Area2D
@onready var navagent : NavigationAgent2D = $NavigationAgent2D
@onready var mind_timeout : Timer = $MindTimeOut


var preylist : Array 
var predatorlist : Array 
var blacklistprey : Array[Animal]

func _ready() -> void:
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
		mind_timeout.timeout.connect(func(): blacklistprey.clear())

func _on_vision_body_entered(body: Node2D) -> void:
	# check predator or prey
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			if (not body in blacklistprey):
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

@abstract func _physics_process(delta: float) -> void
@abstract func player_movement(_delta: float) -> void

func _on_eating_area_body_entered(body: Node2D) -> void:
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			if get_parent() is Player:
				var player: Player = get_parent() as Player
				player.eat(body.entity_resource.exp_gain, body.entity_resource.hunger_gain)
			body.die()
