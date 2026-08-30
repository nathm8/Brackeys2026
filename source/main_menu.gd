extends Node2D

func _ready():
    %Start.pressed.connect(start_game)
    %LevelSelect.pressed.connect(toggle_levels)
    %Options.pressed.connect(toggle_options)

    get_node("MarginContainer/VBoxContainer/LevelContainer/Tutorial").pressed.connect(start_game)
    get_node("MarginContainer/VBoxContainer/LevelContainer/LevelOne").pressed.connect(func f(): get_tree().change_scene_to_file("res://scenes/interstitial1.tscn"))
    get_node("MarginContainer/VBoxContainer/LevelContainer/LevelTwo").pressed.connect(func f(): get_tree().change_scene_to_file("res://scenes/interstitial2.tscn"))
    get_node("MarginContainer/VBoxContainer/LevelContainer/LevelThree").pressed.connect(func f(): get_tree().change_scene_to_file("res://scenes/interstitial3.tscn"))

    var shader_check = %ShaderCheck
    %ShaderCheck.pressed.connect(func f(): Globals.shader_enabled = shader_check.button_pressed)

    %MusicVolume.value_changed.connect(Music.set_volume)
    %MuteMusic.toggled.connect(func f(_v): Music.enabled = not %MuteMusic.button_pressed)

func start_game():
    Music.play_level_music()
    get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func toggle_levels():
    %LevelContainer.visible = not %LevelContainer.visible
    if %LevelContainer.visible:
        %OptionsContainer.visible = false
        %Options.button_pressed = false

func toggle_options():
    %OptionsContainer.visible = not %OptionsContainer.visible
    if %OptionsContainer.visible:
        %LevelContainer.visible = false
        %LevelSelect.button_pressed = false
