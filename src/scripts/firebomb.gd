extends KinematicBody

onready var aoe = preload('res://scenes/entities/aoe.tscn')
export var damage := 10.0
export var damping = 0.2

var direction = Vector3.ZERO

var _velocity = Vector3.ZERO

func _ready():
	_velocity = direction * 15.0
	pass
	
func _explode():
	var entity = aoe.instance()
	entity.damage = damage
	entity.transform = entity.transform.scaled(Vector3(3.0, 1.0, 3.0))
	entity.transform.origin = global_transform.origin
	get_parent().add_child(entity)
	queue_free()
	
func _physics_process(delta):
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, 0.785398, false)
	_velocity.y = -10.0
	if is_on_floor():
		_velocity.x *= (1.0 - damping)
		_velocity.z *= (1.0 - damping)

func _on_Timer_timeout():
	_explode()
