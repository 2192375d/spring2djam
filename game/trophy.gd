extends Area2D

@export var label: Label
@export var audio_player: AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() is Player:
		label.show()
		audio_player.play()
		queue_free()
