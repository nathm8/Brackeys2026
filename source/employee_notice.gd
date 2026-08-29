extends Node2D

func _ready():
	get_tree().paused = true
	get_node("Continue").pressed.connect(close_panel)
	get_node("LevelSelect").pressed.connect(toggle_levels)
	get_node("Options").pressed.connect(toggle_options)

	get_node("LevelPanel/LevelOne").pressed.connect(start_game)

	get_node("OptionsPanel/CheckButton").pressed.connect(func f(): Globals.shader_enabled = get_node("OptionsPanel/CheckButton").button_pressed)

func close_panel():
	self.hide()

func toggle_levels():
	get_node("LevelPanel").visible = not get_node("LevelPanel").visible
	if get_node("LevelPanel").visible:
		get_node("OptionsPanel").visible = false

func toggle_options():
	get_node("OptionsPanel").visible = not get_node("OptionsPanel").visible
	if get_node("Options").visible:
		get_node("LevelPanel").visible = false
