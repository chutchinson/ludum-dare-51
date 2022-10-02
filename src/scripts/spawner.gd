extends Spatial

onready var enemy = preload('res://scenes/entities/enemies/knight.tscn')

export(Resource) var shape
export var min_distance_from_player := 5.0
export(int, LAYERS_3D_PHYSICS) var collision_mask

onready var _shape = _create_check_shape()

func _create_check_shape() -> SphereShape:
	var sphere = SphereShape.new()
	sphere.radius = 2.0
	return sphere

func _ready():
	Game.connect('spawn', self, '_on_spawn')
	pass
	
func _on_spawn():
	print('spawn')
	_spawn()

func _distance_from_player (pos: Vector3) -> float:
	var players = get_tree().get_nodes_in_group('player')
	var player = players.pop_back()
	return pos.distance_to(player.transform.origin)
	
func _find_position():
	# TODO: breakout on error
	
	while (true):
		var pos = _random_point()
		var distance = _distance_from_player(pos)
		
		if distance < 5:
			continue
		
		var space = get_world().direct_space_state
		var sphere = SphereShape.new()
		var query = PhysicsShapeQueryParameters.new()
		
		query.collision_mask = collision_mask
		query.collide_with_areas = false
		query.collide_with_bodies = true
		query.set_shape(_shape)
		
		var collisions = space.collide_shape(query, 3)
		
		if collisions == null or len(collisions) <= 0:
			return pos
	
func _spawn():
	var pos = _find_position()
	var entity = _spawn_at(pos)
	pass

func _spawn_at(pos: Vector3) -> Spatial:
	var entity = enemy.instance()
	entity.transform.origin = pos
	var parent = get_parent()
	parent.call_deferred('add_child', entity)
	return entity
	
func _random_point() -> Vector3:
	var radius = 5.0
	var angle = rand_range(0, TAU)
	var distance = rand_range(0, 10.0)
	var px = distance * cos(angle)
	var pz = distance * sin(angle)
	return Vector3(px, 0.0, pz)
