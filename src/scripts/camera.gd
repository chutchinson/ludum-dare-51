extends Camera

export var speed = 0.2
export var distance = 6.0

var _height = 0

func _ready():
	_height = transform.origin.y
	pass
	
func _find_player() -> Spatial:
	var players = get_tree().get_nodes_in_group('player')
	var player = players.pop_front()
	return player as Spatial
	
func _process(delta):
	var target = _find_player()
	if not target: return
	
	var dest_xform = target.global_transform
	var dest_x = dest_xform.origin.x
	var dest_y = _height
	var dest_z = dest_xform.origin.z + distance
	var destination = Vector3(dest_x, dest_y, dest_z)
	
	$Tween.interpolate_property(self, 'transform:origin', transform.origin, destination, speed, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
		
	pass
