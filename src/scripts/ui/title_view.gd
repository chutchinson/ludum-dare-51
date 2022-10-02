extends Control
	
func _on_Exit_pressed():
	Game.exit()
	pass

func _on_Credits_pressed():
	Game.navigate_to(Game.credits)
	pass

func _on_Start_pressed():
	Game.navigate_to(Game.start)
	pass

func _on_Settings_pressed():
	Game.navigate_to(Game.settings)
	pass
