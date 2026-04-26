extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_play_pressed() -> void:
	AudioManager.play_ui_click()
	print("Play pressed")
	get_tree().change_scene_to_file("res://game/world.tscn")


func _on_btn_options_pressed() -> void:
	AudioManager.play_ui_click()
	print("Options pressed")
	# the rest is to be implemented once pause/settings menu is made
	pass

func _on_btn_exit_pressed() -> void:
	AudioManager.play_ui_click()
	print("Exit pressed")
	get_tree().quit()
