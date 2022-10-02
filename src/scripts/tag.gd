extends Spatial

onready var _target = get_parent() as Combatant
onready var _label = $VBoxContainer/Label
onready var _health = $VBoxContainer/ProgressBar

func _process(delta):
	
	var health = _target.health / _target.max_health
	var health_percent = clamp(health * 100, 0, 100)
	
	if health_percent != _health.value:
		$Tween.interpolate_method(self, '_set_health', _health.value, health_percent, 0.1)
		$Tween.start()

func _set_health(value: float):
	_health.value = value
