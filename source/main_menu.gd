extends Node2D

func _ready():
    get_node("Start").pressed.connect(start_game)
    get_node("LevelSelect").pressed.connect(toggle_levels)
    get_node("Options").pressed.connect(toggle_options)

    get_node("LevelPanel/LevelOne").pressed.connect(start_game)

    get_node("OptionsPanel/CheckButton").pressed.connect(func f(): Globals.shader_enabled = get_node("OptionsPanel/CheckButton").button_pressed)

func start_game():
    get_tree().change_scene_to_file("res://scenes/interstitial1.tscn")

func toggle_levels():
    get_node("LevelPanel").visible = not get_node("LevelPanel").visible
    if get_node("LevelPanel").visible:
        get_node("OptionsPanel").visible = false

func toggle_options():
    get_node("OptionsPanel").visible = not get_node("OptionsPanel").visible
    if get_node("Options").visible:
        get_node("LevelPanel").visible = false
