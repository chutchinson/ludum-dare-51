extends Control

export(NodePath) var time_label

onready var _time_label = get_node(time_label) as Label

func _process(delta):
	_update_time()
	pass

func _update_time():
	var time = abs(10.0 - Game.spawn_time)
	var seconds = int(time)
	var milliseconds = int((time - seconds) * 10)
	
	_time_label.text = '%d.%d' % [seconds, milliseconds]
