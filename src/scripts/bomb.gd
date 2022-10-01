extends KinematicBody

export var damage := 10.0
export var damping := 0.2

onready var anim: AnimationPlayer = $AnimationPlayer
onready var hitbox: Area = $HitArea

var _bounces = 0
var _velocity = Vector3.FORWARD * 12.0

func _on_explode():
	anim.play('explode')
	_damage_enemies_in_area()
	pass
	
func _set_velocity(value: float):
	_velocity.z = value
	pass
	
func _damage_enemies_in_area():
	var entities = hitbox.get_overlapping_bodies()
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
