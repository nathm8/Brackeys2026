extends Button

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    pressed.connect(_button_pressed)

func _button_pressed():
    get_tree().paused = button_pressed