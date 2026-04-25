extends Node2D

class_name World

func _ready() -> void:
	GameSession.world = self
	GameSession.change_playing_animal(Constants.EntityID.KIWI)


func _on_hunger_drain_timer_timeout() -> void:
	GameSession.player_drain_hunger()
