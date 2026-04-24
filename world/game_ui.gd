extends CanvasLayer

class_name GameUI

@export var hunger_bar: ProgressBar

func _ready() -> void:
	GameSession.player_hunger_bar = hunger_bar
