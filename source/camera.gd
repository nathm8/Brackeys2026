extends Sprite2D

func _process(_delta):
	var camera = get_node("CameraIrisAnchor")
	camera.look_at(get_viewport().get_mouse_position())
	if camera.rotation < 0.3:
		camera.rotation = 0.3
	if camera.rotation > PI - 0.3:
		camera.rotation = PI - 0.3
