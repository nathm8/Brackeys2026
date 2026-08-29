extends "res://source/main.gd"

var tutorial_step = 1

func _ready():
    # simplified rules/actions
    unlocked_rules = ["ComputerWork", "RedInsert", "DamagedShred"]
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
        var task = Task.ComputerWork.new(self, employee)
        task.is_correct = false
        to_do = [task]
        employee._process(0)
        print(to_do)
