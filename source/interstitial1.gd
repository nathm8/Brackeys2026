extends Control

func _ready():
    get_node("Button").pressed.connect(func f(): get_tree().change_scene_to_file("res://scenes/level1.tscn"))
    