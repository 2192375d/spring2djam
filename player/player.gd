extends CharacterBody2D

@export var speed: float

var current_hunger: float
var full_hunger: float

func upgrade(new_full_hunger: float) -> void:
	 #change the type of animal to something new
	full_hunger = new_full_hunger
	
	GameSession.player_hunger_bar.max_value = full_hunger
	current_hunger = full_hunger
	GameSession.player_hunger_bar.value = current_hunger

func _ready() -> void:
	
	upgrade(300)

func _physics_process(_delta: float) -> void:
	
	#velocity.y += Constants.GRAVITY * delta
	
	velocity = Vector2.ZERO
	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()
