extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_death_screen() -> void:
	show()
	# get_tree().paused = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	# get_tree().paused = false
	AudioManager.play_ui_click()
	get_tree().change_scene_to_file("res://game/main-menu.tscn")
