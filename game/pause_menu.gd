extends CanvasLayer

@onready var resume_button: TextureButton = $Control/VBoxContainer/BtnResume
@onready var options_button: TextureButton = $Control/VBoxContainer/BtnOptions
@onready var menu_button: TextureButton = $Control/VBoxContainer/BtnMainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()
	$Control/ColorRect.modulate.a = 0.0
	$Control/VBoxContainer.modulate.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_pause_menu() -> void:
	show()
	get_tree().paused = true

	var tween = create_tween()

	tween.parallel().tween_property(
		$Control/ColorRect,
		"modulate:a",
		1.0,
		0.25
	)

	tween.parallel().tween_property(
		$Control/VBoxContainer,
		"modulate:a",
		1.0,
		0.25
	)

func hide_pause_menu() -> void:
	var tween = create_tween()

	tween.parallel().tween_property(
		$Control/ColorRect,
		"modulate:a",
		0.0,
		0.2
	)

	tween.parallel().tween_property(
		$Control/VBoxContainer,
		"modulate:a",
		0.0,
		0.2
	)

	await tween.finished

	hide()
	get_tree().paused = false

func _on_btn_resume_pressed() -> void:
	hide_pause_menu()

func _on_btn_options_pressed() -> void:
	pass # Replace with function body.

func _on_btn_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/main-menu.tscn")
