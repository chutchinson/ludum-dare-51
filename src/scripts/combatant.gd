extends KinematicBody
class_name Combatant

onready var bomb = preload('res://scenes/entities/bomb.tscn')
onready var boomerang = preload('res://scenes/entities/boomerang.tscn')

export var display_name = ''
export var has_shield = false
export var has_sword = false
export var has_boomerang = false
export var has_fire_bomb = false
export var speed = 8.0
export var max_health = 30.0
export var invincible = false
export var turn_rate = 0.1

var input = Vector2.ZERO
var health = 0.0
var defending = false

enum PlayerState {
	IDLE = 0,
	MOVE = 1,
	ATTACK = 2,
	DEFEND = 3,
	DAMAGE = 4,
	KNOCKBACK = 5,
	STUN = 6
}

var _velocity = Vector3.ZERO
var _state = PlayerState.MOVE
var _stunned = false
var _hit = false
var _target : Spatial = null

onready var _items = [bomb, boomerang]
var _selected_item = 0

onready var anim = $AnimationTree.get('parameters/playback') as AnimationNodeStateMachinePlayback
	
func _ready():
	anim.start('move')
	input = Vector2.ZERO
	health = max_health
	pass
	
func _find_next_closest_target():
	var entities = get_tree().get_nodes_in_group('combatant')
	for entity in entities:
		if entity == self: continue
		if entity.is_in_group('player'): continue
		if entity == _target: continue
		return entity
	return null

func hit_enable():
	_hit = true

func hit_disable():
	_hit = false
	
func _can_take_damage():
	if invincible: return false
	if defending: return false
	return $HitCooldown.time_left <= 0.0

func _apply_damage(value: float):

	$HitCooldown.start(0.0)
	
	health = max(health - value, 0.0)
	
	if health <= 0.0:
		_die()
	
func damage(sender: Spatial, value: float):
	if not _can_take_damage(): return
	
#	_state = PlayerState.KNOCKBACK
#
#	_velocity.x = 0.0
#	_velocity.y = 0.0
#	_velocity.z += 40.0
#
#	yield (get_tree().create_timer(0.25), 'timeout')
	
	_apply_damage(value)
	_state = PlayerState.MOVE

func _set_health(value: float):
	health = value

func _die():
	print('ded')
	queue_free()
	
func _can_use():
	if $ActionCooldown.time_left > 0.0: return false
	return true
	
func _can_switch_item():
	return true
	
func select_target():
	_target = _find_next_closest_target()
	
func clear_target():
	_target = null
	
func select_next_item(direction: int):
	_selected_item = wrapi(_selected_item + sign(direction), 0, len(_items))
	
func use():
	if not _can_use(): return
	
	var entity_type = _items[_selected_item]
	var entity = entity_type.instance()
	
	if 'direction' in entity:
		entity.direction = -transform.basis.z
	if 'source' in entity:
		entity.source = self
		
	entity.transform.origin = $Holster.global_transform.origin
	var parent = get_parent()
	parent.add_child(entity)

func attack():
	if $AttackCooldown.time_left > 0.0: return
	$AnimationTree.set('parameters/move/attack/active', true)
	$AttackCooldown.start(0.0)
	_velocity = -global_transform.basis.z * 10.0
	_velocity.y = 0.0
	_state = PlayerState.ATTACK
	yield($AttackCooldown, 'timeout')
	_state = PlayerState.MOVE
	pass
	
func _can_start_defending():
	return true

func defend(state: bool):
	if defending:
		defending = false
		$AnimationTree.set('parameters/move/defend/blend_amount', 0.0)
	elif not defending and _can_start_defending():
		defending = true
		$AnimationTree.set('parameters/move/defend/blend_amount', 1.0)
	
func boomerang_return(node: Spatial):
	print('boomerang returned!')
	
func _process(delta):
	var mask = Vector3(1.0, 0.0, 1.0)
	var target = global_transform.origin + (_velocity * mask).normalized()
	
	if input.length_squared() > 0.0:
		$Tween.stop_all()
		$Tween.interpolate_method(self, '_set_look_at', 
			(global_transform.origin * mask) - (transform.basis.z * mask), 
			target * mask, turn_rate, Tween.TRANS_LINEAR)
		$Tween.start()
		
func _set_look_at(pos: Vector3):
	look_at(pos, Vector3.UP)
	
func _physics_process(delta):
	
	if _target:
		var target_pos = _target.global_transform.origin
		target_pos.y = 0.0
		look_at(target_pos, Vector3.UP)
	
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
		
	if input.length_squared() <= 0.0:
		_velocity.x *= 0.9
		_velocity.z *= 0.9

	var dx = input.x
	var dz = input.y
	var direction = Vector3(dx, 0, dz)
	var delta_v = direction.normalized() * speed
	
	if _target:
		# strafe and move towards / away
		var vx = transform.basis.x * delta_v.x * 0.8
		var vz = transform.basis.z * delta_v.z
		var movement = vx + vz
		
		_velocity.x = movement.x
		_velocity.z = movement.z 
	else:
		_velocity.x = delta_v.x
		_velocity.z = delta_v.z

	_apply_movement(_velocity)
	
func _distance_to_target():
	return global_transform.origin.distance_to(_target.global_transform.origin)
	
func _apply_movement(dv: Vector3):
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, 0.785398, false)
	_velocity.y = -10.0
	_velocity.z *= 0.9
	_velocity.x *= 0.9
	
func _knockback(delta):
	_apply_movement(_velocity)
	pass
	
func _idle(delta):
	pass
	
func _attack(delta):
	_apply_movement(_velocity)
	pass

