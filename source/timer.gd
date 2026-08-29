extends TextureProgressBar

# used in main.finalise
var paused = false

func _process(delta):
	if not paused:
		value -= delta
