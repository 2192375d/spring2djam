extends Node2D

@onready var sprite = $Worm

var start_x : float
var t := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_x = position.x
	sprite.play("wiggle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	position.x = start_x + sin(t * 0.3) * 270
