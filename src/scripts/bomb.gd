extends KinematicBody

export var fuse_time = 10.0
export var speed = 25.0
export var damage := 10.0
export var damping := 0.2

var direction = Vector3.ZERO

onready var _anim: AnimationPlayer = $AnimationPlayer
onready var _hitbox: Area = $HitArea

var _bounces = 0
var _velocity = Vector3.ZERO

func _ready():
	_velocity = direction * speed
	$ExplodeTimer.wait_time = fuse_time

func _on_explode():
	_anim.play('explode')
	_damage_enemies_in_area()
	pass
	
func _damage_enemies_in_area():
	var entities = _hitbox.get_overlapping_bodies()
	for entity in entities:
		if entity.has_method('damage'):
			entity.damage(self, damage)
	
func _remove():
	queue_free()

func _physics_process(delta):
		
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, 0.785398, false)
	_velocity.y = -15.0
	
	if $RayCast.is_colliding():
		
		if _bounces == 0:
			_velocity.y = 360 * delta
			_bounces += 1
		if _bounces == 1:
			_velocity.y = 180 * delta
			_bounces += 1
			
		_velocity.x *= (1.0 - damping)
		_velocity.z *= (1.0 - damping)
		
	pass
