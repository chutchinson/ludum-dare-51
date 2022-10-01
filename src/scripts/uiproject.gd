extends Control

func _physics_process(delta):
	var parent = get_parent() as Spatial
	var pos = parent.global_transform.origin
	var camera = get_tree().root.get_camera()
	var screen_pos = camera.unproject_position(pos)
	var size = get_rect().size
	screen_pos.x -= size.x / 2
	screen_pos.y -= size.y
	set_position(screen_pos)
