class_name Spawner
extends Node2D

@export var allowed_enemies : Array[Constants.EntityID]
@export var rect : Area2D
@export var timer : Timer

func _ready() -> void:
	timer.timeout.connect(func() : spawn_entity(allowed_enemies[randi_range(0, len(allowed_enemies)-1)]))

func random_position(spawn_enum : int) -> Vector2:
	var top_left = rect.get_node("CollisionShape2D").shape.get_rect().position
	var bottom_right = rect.get_node("CollisionShape2D").shape.get_rect().end
	return Vector2( randi_range(top_left.x, bottom_right.x), randi_range(top_left.y, bottom_right.y) )

func spawn_entity(entityenum : int):
	print(entityenum)
	var animal_scene: PackedScene = Constants.entity_dict.get(entityenum)
	if (animal_scene):
		var animal : Animal = animal_scene.instantiate()
		self.add_child(animal)
		# get animal spawn position enums
		var pos : Vector2 = random_position(animal.entity_resource.spawn_height)
		# ensure non-collisions
		while animal.test_move(transform, pos) == true:
			pos.y += 50
		animal.global_position = pos
		animal.position = pos
		animal.domain_point = pos
		
