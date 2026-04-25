extends CanvasLayer

class_name GameUI

@export var exp_bar: ProgressBar
@export var hunger_bar: ProgressBar

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
