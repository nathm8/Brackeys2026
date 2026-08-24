extends Node2D

func _ready():
    pass

func _process(_delta: float):
    pass

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
        if event.pressed and event.keycode == KEY_ENTER:
            get_tree().reload_current_scene()
        
