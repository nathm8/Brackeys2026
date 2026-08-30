extends Control

@onready var continue_button = $Background/MarginContainer/VBoxContainer/Button

func _ready():
	continue_button.pressed.connect(func f(): get_tree().change_scene_to_file("res://scenes/level2.tscn"); Music.play_level_music())
	
