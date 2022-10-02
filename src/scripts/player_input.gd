extends Node

onready var _entity := get_parent() as Combatant

func _process(delta):
	
	var input = Vector2.ZERO
	
	if Input.is_action_pressed('game_move_left'):
		input += Vector2(-1.0, 0.0)
	if Input.is_action_pressed('game_move_right'):
		input += Vector2(1.0, 0.0)
	if Input.is_action_pressed('game_move_down'):
		input += Vector2(0.0, 1.0)
	if Input.is_action_pressed('game_move_up'):
		input += Vector2(0.0, -1.0)

	_entity.input = input

	if Input.is_action_just_pressed('game_use'):
		_entity.use()
	if Input.is_action_just_pressed('game_attack'):
		_entity.attack()
	if Input.is_action_just_pressed('game_defend'):
		_entity.defend(true)
	if Input.is_action_just_released('game_defend'):
		_entity.defend(false)
		
	if Input.is_action_just_pressed('game_target'):
		_entity.select_target()
		
	if Input.is_action_just_pressed('game_switch_back'):
		_entity.select_next_item(-1)
	if Input.is_action_just_pressed('game_switch_forward'):
		_entity.select_next_item(1)

#	if Input.is_action_just_pressed('game_defend'):
#		print('defend')
#		_defending = true
#		$AnimationTree.set('parameters/move/defend/blend_amount', 1.0)
#
#	if Input.is_action_just_released('game_defend'):
#		print('stop defend')
#		_defending = false
#		$AnimationTree.set('parameters/move/defend/blend_amount', 0.0)
		

#	if Input.is_action_just_pressed('game_attack'):
#		_do_attack()
#	if Input.is_action_just_pressed('game_use'):
#		_use()
		
#	if Input.is_action_just_pressed('game_input_next'):
#		_switch_item()
		
	
		
	pass
