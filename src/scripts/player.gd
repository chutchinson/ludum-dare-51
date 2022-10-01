extends KinematicBody

onready var bomb = preload('res://scenes/entities/bomb.tscn')

enum PlayerState {
	IDLE = 0,
	MOVE = 1,
	ATTACK = 2,
	DEFEND = 3,
	DAMAGE = 4,
	KNOCKBACK = 5,
	STUN = 6
}

export var speed = 8.0

var _velocity = Vector3.ZERO
var _state = PlayerState.MOVE
var _input = Vector2.ZERO
var _stunned = false
var _hit = false

var _has_shield = false
var _has_bomb = false
var _has_boomerang = false
var _has_fire_bomb = false

onready var anim = $AnimationTree.get('parameters/playback') as AnimationNodeStateMachinePlayback

func hit_enable():
	_hit = true

func hit_disable():
	_hit = false

func _ready():
	anim.start('RESET')
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

	if Input.is_action_just_pressed('game_attack'):
		_do_attack()
	if Input.is_action_just_pressed('game_use'):
		_use()
		
	pass
	
func damage(sender: Spatial, value: float):
	_state = PlayerState.KNOCKBACK
		
	_velocity.x = 0.0
	_velocity.y = 0.0
	_velocity.z += 40.0
	
	yield (get_tree().create_timer(0.25), 'timeout')
	
	_state = PlayerState.MOVE
	
func _can_use():
	if $ActionCooldown.time_left > 0.0: return false
	var entity = bomb.instance()
	entity.transform.origin = $Holster.global_transform.origin
	print(entity.transform.origin)
	var parent = get_parent()
	parent.add_child(entity)
	
func _use():
	if not _can_use(): return
	print('use')

func _do_attack():
	if $AttackCooldown.time_left > 0.0: return
	anim.stop()
	anim.travel('slash')

	$AttackCooldown.start(0.0)
	pass
	
func _physics_process(delta):
	
	if _hit:
		var bodies = $HitBox.get_overlapping_bodies()
		for body in bodies:
			if body != self and body.has_method('damage'):
				body.damage(self, $Sword.damage)
	
	match _state:
		PlayerState.MOVE: _move(delta)
		PlayerState.KNOCKBACK: _knockback(delta)
		
	pass
	
func _move(delta):
		
	if _input.length_squared() <= 0.0:
		_velocity.x *= 0.9
		_velocity.z *= 0.9

	var direction = Vector3(_input.x, 0.0, _input.y)
	var delta_v = direction.normalized() * speed
	
	_velocity.x = delta_v.x
	_velocity.z = delta_v.z
	_velocity.y =- 10.0
	
	_apply_movement(_velocity)
	
func _apply_movement(dv: Vector3):
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, 0.785398, false)
	_velocity.z *= 0.9
	_velocity.x *= 0.9
	
func _knockback(delta):
	_apply_movement(_velocity)
	pass
	
func _idle(delta):
	pass
	
func _attack(delta):
	pass
