extends CanvasLayer

@onready var music_slider = $Control/VBoxContainer/MusicSlider
@onready var sfx_slider = $Control/VBoxContainer/SFXSlider
@onready var ambient_slider = $Control/VBoxContainer/AmbientSlider

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")
var ambient_bus := AudioServer.get_bus_index("Ambient")
var opened_from := "main_menu"

@export var pause_menu: CanvasLayer
@export var main_menu_label: Label
@export var main_menu_box: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_audio_settings()

func open_options(source: String) -> void:
	opened_from = source
	show()

func load_audio_settings():
	var config = ConfigFile.new()

	if config.load("user://settings.cfg") == OK:
		music_slider.value = config.get_value("audio", "music", 100)
		sfx_slider.value = config.get_value("audio", "sfx", 100)
		ambient_slider.value = config.get_value("audio", "ambient", 100)

func save_audio_settings():
	var config = ConfigFile.new()

	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.set_value("audio", "ambient", ambient_slider.value)

	config.save("user://settings.cfg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func percent_to_db(value: float) -> float:
	if value <= 0:
		return -80.0
	return linear_to_db(value / 100.0)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		music_bus,
		percent_to_db(value)
	)
	save_audio_settings()


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		sfx_bus,
		percent_to_db(value)
	)
	save_audio_settings()


func _on_ambient_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		ambient_bus,
		percent_to_db(value)
	)
	save_audio_settings()


func _on_back_btn_pressed() -> void:
	AudioManager.play_ui_click()
	hide()

	if opened_from == "pause_menu":
		pause_menu.show_pause_menu()

	elif opened_from == "main_menu":
		main_menu_label.show()
		main_menu_box.show()
