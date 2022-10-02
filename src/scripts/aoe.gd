extends Spatial

export var lifetime = 5.0
export var damage = 2.0
export var tick_rate = 1.0

onready var _hitbox = $Area

var _time = 0.0

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()

func _process(delta):
	if _time >= tick_rate:
		_time = 0.0
		_tick()
		
	_time += delta
	pass
	
func _destroy():
	queue_free()
	
func _tick():
	_damage_entities_in_area()
	pass
	
func _damage_entities_in_area():
	for entity in _hitbox.get_overlapping_bodies():
		if entity.is_in_group('enemy') or entity.is_in_group('player'):
			entity.damage(self, damage)

func _on_Timer_timeout():
	_destroy()
