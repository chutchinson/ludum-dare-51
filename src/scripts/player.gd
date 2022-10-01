extends KinematicBody

enum PlayerState {
	IDLE = 0,
	MOVE = 1,
	ATTACK = 2,
	DEFEND = 3,
	DAMAGE = 4
}

export var speed = 8.0

var _velocity = Vector3.ZERO
var _state = PlayerState.IDLE
var _input = Vector2.ZERO

func _ready():
	pass
	
func _process(delta):
	_input = Vector2.ZERO
	
	if Input.is_action_pressed('game_move_left'):
		_input += Vector2(0.0, 1.0)
	if Input.is_action_pressed('game_move_right'):
		_input += Vector2(0.0, -1.0)
	if Input.is_action_pressed('game_move_down'):
		_input += Vector2(1.0, 0.0)
	if Input.is_action_pressed('game_move_up'):
		_input += Vector2(-1.0, 0.0)
		
	pass
	
func _physics_process(delta):
	
	if _input.length_squared() < 0.0:
		_velocity = Vector3.ZERO

	var direction = Vector3(_input.x, 0.0, _input.y)
	var delta_v = direction.normalized() * speed
	
#	if not _is_in_arena(transform.origin + delta_v * delta):
#		return
	
	_velocity = delta_v
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, 0.785398, false)
		
	pass
	
#func _is_in_arena(pos: Vector3) -> bool:
#	var diameter = 10.0
#	var cx = abs(pow(pos.x, 2.0))
#	var cz = abs(pow(pos.z, 2.0))
#	return sqrt(cx + cz) <= diameter
	
func _idle(delta):
	pass
	
func _move(delta):
	pass
	
func _attack(delta):
	pass

func _use(delta):
	pass
