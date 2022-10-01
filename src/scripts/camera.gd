extends Camera

export var speed = 0.2
export var distance = 6.0

var target : Spatial setget _set_target, _get_target

var _height = 0
var _target_pos = Vector3.ZERO

func _get_target() -> Spatial:
	return target

func _set_target(value: Spatial):
	target = value

func _ready():
	_height = transform.origin.y # save start position
	pass
	
func _process(delta):
	if not target: return
	
	var dest_x = target.transform.origin.x + distance
	var dest_y = _height
	var dest_z = target.transform.origin.z
	var destination = Vector3(dest_x, dest_y, dest_z)
	
	$Tween.interpolate_property(self, 'transform:origin', transform.origin, destination, speed, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
		
	pass
