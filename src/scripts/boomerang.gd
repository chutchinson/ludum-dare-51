extends KinematicBody

export var damage = 2.0
export var speed = 10.0
export var degrees_per_second = -720.0

var direction = Vector3.ZERO
var source: Spatial = null

enum BoomerangState {
	MOVE,
	RETURN
}
onready var _height = global_transform.origin.y

var _velocity = Vector3.ZERO
var _state = BoomerangState.MOVE

func _ready():
	_velocity = direction * speed

func _move(delta):
	var collision = _apply_movement(_velocity, delta)
	
	if collision != null and collision.collider.is_in_group('enemy'):
		_velocity = -_velocity
		_state = BoomerangState.RETURN
		_apply_damage(collision.collider)
			
	pass
	
func _apply_damage(target):
	if target.has_method('damage'):
		target.damage(self, damage)
	
func _return(delta):
	var velocity = _velocity
	
	if source != null:
		var mask = Vector3(1.0, 0.0, 1.0)
		var source_pos = source.global_transform.origin * mask
		var self_pos = global_transform.origin * mask
		var direction = source_pos - self_pos
		velocity = direction.normalized()
		velocity.y = 0
		velocity *= speed * 2.0
		
	var collision = _apply_movement(velocity, delta)
	
	if collision != null:
		if collision.collider.has_method('boomerang_return'):
			collision.collider.boomerang_return(self)
		queue_free()
		
	pass

func _apply_movement(velocity: Vector3, delta: float) -> KinematicCollision:
	rotation_degrees.y += degrees_per_second * delta
	return move_and_collide(velocity * delta, false, false)
		
func _physics_process(delta):
	match _state:
		BoomerangState.MOVE: _move(delta)
		BoomerangState.RETURN: _return(delta)

func _on_Timer_timeout():
	if _state == BoomerangState.MOVE:
		_state = BoomerangState.RETURN
