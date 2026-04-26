extends CanvasLayer

class_name GameUI

@export var exp_bar: ProgressBar
@export var hunger_bar: ProgressBar

@onready var death_screen: CanvasLayer = $DeathScreen
@onready var pause_menu: CanvasLayer = $PauseMenu

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
