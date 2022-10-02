extends View

func _ready():
	$AnimationPlayer.play('show')

func _go_back():
	Game.navigate_to(Game.title)

func _on_GoBack_pressed():
	Game.navigate_to(Game.title)
