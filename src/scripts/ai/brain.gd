extends Node
class_name Brain

onready var _entity = get_parent() as Combatant

var input = Vector2.ZERO
var use = false
var attack = false
var defend = false

func _find_player() -> Combatant:
	var players = get_tree().get_nodes_in_group('player')
	var player = players.pop_front()
	return player as Combatant
		
func _think(delta):
	pass

func _physics_process(delta):
	_think(delta)
	
	_entity.input = input
	
	if Input.is_key_pressed(KEY_LEFT):
		_entity.input.x = -1.0
	if Input.is_key_pressed(KEY_RIGHT):
		_entity.input.x = 1.0
	if Input.is_key_pressed(KEY_UP):
		_entity.input.y = -1.0
	if Input.is_key_pressed(KEY_DOWN):
		_entity.input.y = 1.0
		
	if use:
		_entity.use()
		use = false
		
	if attack:
		_entity.attack()
		attack = false
		
	if defend and not _entity.defending:
		_entity.defend(true)
