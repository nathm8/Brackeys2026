extends Sprite2D

var in_use = false

func set_working():
	texture = preload("res://resources/monitor_working.svg")

func set_working_red():
	texture = preload("res://resources/monitor_red.svg")

func set_working_blue():
	texture = preload("res://resources/monitor_blue.svg")

func set_slacking():
	texture = preload("res://resources/monitor_slacking.svg")

func set_off():
	texture = preload("res://resources/monitor_off.svg")
