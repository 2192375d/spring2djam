class_name Spawner
extends Node2D

@export var allowed_enemies : Array[Constants.EntityID]
@export var rect : Area2D
@export var timer : Timer

func _ready() -> void:
	if timer == null or allowed_enemies.is_empty():
		return

	timer.timeout.connect(func() : spawn_entity(allowed_enemies[randi_range(0, len(allowed_enemies)-1)]))
	if timer.is_stopped():
		timer.start()

func random_position(spawn_enum : int) -> Vector2:
	if rect == null:
		return global_position

	var collision_shape := rect.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape == null or collision_shape.shape == null:
		return rect.global_position

	var shape_rect: Rect2 = collision_shape.shape.get_rect()
	var top_left: Vector2 = collision_shape.global_position + shape_rect.position
	var bottom_right: Vector2 = collision_shape.global_position + shape_rect.end
	return Vector2(
		randi_range(int(top_left.x), int(bottom_right.x)),
		randi_range(int(top_left.y), int(bottom_right.y))
	)

func spawn_entity(entityenum : int):
	var animal_scene: PackedScene = Constants.entity_dict.get(entityenum)
	if animal_scene == null:
		return

	var animal := animal_scene.instantiate() as Animal
	if animal == null:
		return

	add_child(animal)

	var pos: Vector2 = random_position(animal.entity_resource.spawn_height)
	animal.global_position = pos

	if animal is SentientAnimal:
		var sentient_animal := animal as SentientAnimal
		sentient_animal.domain_point = pos
		
