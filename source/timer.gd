extends TextureProgressBar

func _ready():
    value = 0
    
func _process(delta):
    value += delta
    if value > max_value:
        visible = false