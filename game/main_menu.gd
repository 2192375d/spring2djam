extends Control

@onready var label = $Panel/Label
@onready var button_box = $Panel/VBoxContainer
@onready var options_menu = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_ambient()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_play_pressed() -> void:
	AudioManager.stop_ambient()
	AudioManager.play_ui_click()
	print("Play pressed")
	get_tree().change_scene_to_file("res://game/world.tscn")


func _on_btn_options_pressed() -> void:
	AudioManager.play_ui_click()
	print("Options pressed")
	
	label.hide()
	button_box.hide()
	
	options_menu.open_options("main_menu")

func _on_btn_exit_pressed() -> void:
	AudioManager.play_ui_click()
	print("Exit pressed")
	get_tree().quit()
