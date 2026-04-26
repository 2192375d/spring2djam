extends CanvasLayer

class_name GameUI

@export var exp_bar: ProgressBar
@export var hunger_bar: ProgressBar

@onready var death_screen: CanvasLayer = $DeathScreen
@onready var pause_menu: CanvasLayer = $PauseMenu

@onready var gain_popup: Control = $EatGainPopup
@onready var xp_gain_label: Label = $EatGainPopup/VBoxContainer/XpGainLabel
@onready var food_gain_label: Label = $EatGainPopup/VBoxContainer/FoodGainLabel
@onready var gain_popup_timer: Timer = $EatGainPopup/Timer
var gain_popup_tween: Tween

func _ready() -> void:
	gain_popup.set_anchors_preset(Control.PRESET_TOP_LEFT)
	gain_popup.z_index = 1000

func update_exp_bar_max(new_max: float) -> void:
	exp_bar.max_value = new_max

func update_hunger_bar_max(new_max: float) -> void:
	hunger_bar.max_value = new_max

func update_exp_bar(value: float) -> void:
	# play some animation (?)
	exp_bar.value = value

func update_hunger_bar(value: float) -> void:
	# play some animation (?)
	hunger_bar.value = value
	
func show_death_screen() -> void:
	death_screen.show_death_screen()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_menu.hide_pause_menu()
		else:
			pause_menu.show_pause_menu()

func _on_texture_button_pressed() -> void:
	AudioManager.play_ui_click()
	if get_tree().paused:
		pause_menu.hide_pause_menu()
	else:
		pause_menu.show_pause_menu()

func show_gain_popup(xp_gain: float, food_gain: float, world_pos: Vector2) -> void:
	xp_gain_label.text = "+%d XP" % int(round(xp_gain))
	food_gain_label.text = "+%d Food" % int(round(food_gain))

	var screen_pos := get_viewport().get_canvas_transform() * world_pos

	# gain_popup.position = screen_pos + Vector2(-40, -60)
	gain_popup.position = Vector2(200, 200)
	gain_popup.z_index = 1000
	gain_popup.modulate.a = 1.0
	gain_popup.show()

	gain_popup_timer.stop()
	gain_popup_timer.start(2.0)

func _on_timer_timeout() -> void:
	if gain_popup_tween and gain_popup_tween.is_valid():
		gain_popup_tween.kill()

	gain_popup_tween = create_tween()
	gain_popup_tween.tween_property(gain_popup, "modulate:a", 0.0, 0.25)
	await gain_popup_tween.finished
	gain_popup.hide()
