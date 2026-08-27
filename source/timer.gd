extends TextureProgressBar

func _process(delta):
    value += delta
    if value > max_value:
        visible = false