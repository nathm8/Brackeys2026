extends Sprite2D

var in_use = false

func set_working():
    texture = preload("res://resources/monitor_working.svg")

func set_slacking():
    texture = preload("res://resources/monitor_slacking.svg")

func set_off():
    texture = preload("res://resources/monitor_off.svg")            
