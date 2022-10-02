extends Node
	
onready var start = preload('res://scenes/arena.tscn')
onready var title = preload('res://scenes/ui/title.tscn')
onready var credits = preload('res://scenes/ui/credits.tscn')
onready var settings = preload('res://scenes/ui/settings.tscn')
	
enum GameState {
	INIT,
	RUN
}

var _time = 0.0
var _state = GameState.INIT

var spawn_time setget , _get_spawn_time

signal spawn()

func navigate_to(scene: PackedScene):
	get_tree().change_scene_to(scene)
	
func exit():
	get_tree().quit()

func _get_spawn_time():
	return _time
	
func _ready():
	print('started')
	reset()
	pass
	
func _process(delta):
	_time = clamp(_time + delta, 0.0, 10.0)
	
	if Input.is_action_just_pressed('ui_accept'):
		emit_signal('spawn')
	
	return
	
	if _time >= 10.0:
		emit_signal('spawn')
		_time = 0.0

func reset():
#	var players = get_tree().get_nodes_in_group('player')
#	var player = players.pop_front()
#	var viewport = get_tree().current_scene.get_viewport()
#	var camera = viewport.get_camera()
#	camera.target = player
	pass
