extends Brain

enum State {
	WAIT,
	ATTACK,
	DEFEND,
	VICTORY,
	IDLE
}

var _state = State.WAIT

func _ready():
	do_wait()

func do_wait():
	$Timer.start(0.0)
	_state = State.WAIT
	
func do_attack():
	_state = State.ATTACK
	
func do_defend():
	_state = State.DEFEND

func _wait(delta):
	if $Timer.time_left <= 0.0:
		do_attack()
	pass

func _roll(chance: float):
	return rand_range(0, chance) <= 1

func _attack(delta):
	var player = _find_player()
	if not player: return
	
	if _roll(1000):
		use = true
	
	if not _is_target_within(player, 2.5):
		_move_towards(player)
	else:
		defend = true
		if _roll(1000):
			attack = true
			do_wait()
	
	pass
	
func _defend(delta):
	pass

func _think(delta):
	input.x = 0
	input.y = 0
	
	match _state:
		State.WAIT: _wait(delta)
		State.ATTACK: _attack(delta)
		State.DEFEND: _defend(delta)
	
func _is_close_to_edge():
	var center = Vector3(0.0, 0.0, 0.0)
	var distance_from_center = _entity.global_transform.origin.distance_to(center)
	return distance_from_center >= 8.5
	
func _move_towards(target: Spatial):	
	var delta_pos = target.global_transform.origin - _entity.global_transform.origin
	input.x = delta_pos.x
	input.y = delta_pos.z

func _is_low_health():
	var deadband = _entity.health / _entity.max_health
	return deadband < 0.35

func _is_target_within(target: Spatial, distance: float):
	var d = target.global_transform.origin.distance_to(_entity.global_transform.origin)
	return d < distance
