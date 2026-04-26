extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Animal && body.entity_resource.id != Constants.EntityID.EAGLE && body.get_parent() == GameSession.player):
		GameSession.player.change_playing_animal(Constants.EntityID.EAGLE)
