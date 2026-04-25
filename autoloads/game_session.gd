extends Node

var world: World = null
var game_ui: GameUI = null

var player_hunger_value: float = 100:
	set(value):
		player_hunger_value = value
		if game_ui != null:
			game_ui.update_hunger_bar(player_hunger_value)

var player_hunger_max: float = 100:
	set(value):
		player_hunger_max = value
		if game_ui != null:
			game_ui.update_hunger_bar_max(player_hunger_max)

var player_exp_value: float = 30:
	set(value):
		player_exp_value = value
		if game_ui != null:
			game_ui.update_exp_bar(player_exp_value)

var player_exp_max: float = 50:
	set(value):
		player_exp_max = value
		if game_ui != null:
			game_ui.update_exp_bar_max(player_exp_max)

var player: Animal

func change_playing_animal(animal_id: Constants.EntityID) -> void:
	# change player as the correct animal
	
	var new_position: Vector2 = Vector2(200, 30)# change it to starting spawnpoint
	
	if player != null:
		new_position = player.position
	
	var animal_scene: PackedScene = Constants.entity_dict.get(animal_id)
	var animal: Animal = animal_scene.instantiate()
	
	player_hunger_max = animal.entity_resource.hunger_max
	player_hunger_value = float(animal.entity_resource.hunger_max) / 2
	player_exp_max = animal.entity_resource.exp_max
	player_exp_value = 0.0
	
	animal.position = new_position
	
	
	var camera: Camera2D = Camera2D.new()
	camera.scale = Vector2(30, 30)
	animal.add_child(camera)
	world.add_child(animal)

func player_drain_hunger() -> void:
	player_hunger_value -= player_hunger_max / float(50) # decrease 2% each second
	
	if player_hunger_value < 0:
		print("you dead!")
		
