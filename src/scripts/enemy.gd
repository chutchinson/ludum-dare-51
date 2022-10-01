extends KinematicBody
class_name Enemy

export var display_name := 'Enemy'
export var health := 30

export var has_shield = false
export var has_bomb = false
export var has_boomerang = false
export var has_fire_bomb = false

enum EnemyState {
	IDLE,
	MOVE,
	ATTACK,
	DEFEND,
	KNOCKBACK
}

var _state = EnemyState.MOVE
var _defending = false

onready var _health = health

func _get_target():
	var players = get_tree().get_nodes_in_group('player')
	var player = players.pop_front()
	return player

func _can_take_damage():
	return $HitCooldown.time_left <= 0.0

func damage(source: Spatial, value: float):
	if not _can_take_damage(): return
	
	$HitCooldown.start(0.0)
	
	var next_health = max(_health - value, 0.0)
	$Tween.interpolate_method(self, '_set_health', _health, next_health, 0.1, Tween.TRANS_LINEAR)
	$Tween.start()
	
	if next_health == 0.0:
		_die()
		
func _set_health(value: float):
	_health = value
	
func _die():
	print('ded')
	queue_free()

func _ready():
	pass
	
func _process(delta):
	$Tag/VBoxContainer/ProgressBar.value = clamp((_health / health) * 100.0, 0.0, 100.0)
	pass

func _physics_process(delta):
	match _state:
		EnemyState.IDLE: _idle(delta)
		EnemyState.MOVE: _move(delta)
	pass

func _idle(delta):
	pass

func _move(delta):
	pass
