extends Node

var hue: float = 0.0
func _process(_delta: float) -> void:
	
	var i: int = 0
	for guide: Label in get_children():
		var label_hue = fmod(hue + i * 0.1, 1.0)
		guide.modulate = Color.from_hsv(label_hue, 1.0, 1.0)
		i += 1
