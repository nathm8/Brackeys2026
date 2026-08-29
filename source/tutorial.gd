extends "res://source/main.gd"

var tutorial_step = 1

func _ready():
	# simplified rules/actions
	unlocked_rules = ["ComputerWork", "BlueInsert", "DamagedShred"]
	unlocked_abilities = []
	super()
	# disable shader
	get_node("Blur/CanvasLayer/ColorRect").color.a = 0
	get_node("Blur/CanvasLayer2/ColorRect").color.a = 0
	get_node("Blur/CanvasLayer/ColorRect").material.set_shader_parameter("enabled", false)
	get_node("Blur/CanvasLayer2/ColorRect").material.set_shader_parameter("enabled", false)
	# pause
	get_node("UIPanel/MarginContainer/VBoxContainer/TimerContainer/Button").button_pressed = true
	get_node("UIPanel/MarginContainer/VBoxContainer/TimerContainer/Button")._button_pressed()
	get_node("UIPanel/MarginContainer/VBoxContainer/TimerContainer/Button").pressed.connect(advance_tutorial)

var computer_work_pressed = false

func back_to_work_check(event):
	if tutorial_step != 2:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and computer_work_pressed:
			advance_tutorial()

func advance_tutorial():
	tutorial_step += 1
	for ind in find_children("TutorialIndicator*"):
		ind.visible = false
	get_node("TutorialIndicator%s" % str(tutorial_step)).visible = true
	if tutorial_step == 2:
		# disconnect
		get_node("UIPanel/MarginContainer/VBoxContainer/TimerContainer/Button").pressed.disconnect(advance_tutorial)
		# force our employee to play solitaire
		var employee = get_node("Blur/Office/Employee")
		employee.current_task.is_correct = false
		# force the printed form to be an incorrect, damaged blue chip so the
		# rest of the tutorial always has the same correction to teach
		do_task_correctly = [false]
		for printer in find_children("Printer*"):
			printer.forced_form = Task.FormType.Blue
			printer.forced_damaged = true
		# triggers to advance
		var computer_work = get_node("UIPanel/MarginContainer/VBoxContainer/RulesContainer").get_children()[0]
		computer_work.pressed.connect(func f(): computer_work_pressed = true)
		employee.get_node("Area2D").input_event.connect(func f(_v, e, _s): back_to_work_check(e))
	if tutorial_step == 3:
		var tute_tween = create_tween()
		tute_tween.tween_interval(5.0)
		tute_tween.tween_callback(advance_tutorial)
	if tutorial_step == 4:
		var employee = get_node("Blur/Office/Employee")
		# a damaged chip belongs in the recycler whatever its colour
		var rule_number = 3 if employee.current_task.form.damaged else 2
		get_node("TutorialIndicator4/Background/Text").text %= str(rule_number)

func finalise(win):
	super(win)
	get_node("TutorialIndicator4").visible = false
