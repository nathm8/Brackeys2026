extends Sprite2D

const Printer = preload("res://source/printer.gd")

var type

func _init(t):
    type = t
    if type == Task.FormType.Square:
        texture = preload("res://resources/form_square.svg")
    if type == Task.FormType.Circle:
        texture = preload("res://resources/form_circle.svg")
    if type == Task.FormType.Triangle:
        texture = preload("res://resources/form_triangle.svg")
