extends Area2D

@export var label: Label

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() is Player:
		label.show()
		queue_free()
		
