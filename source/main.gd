extends Node2D

# maintain boolean list of whether the next assigned task will be done
# correctly or not
var total_incorrect_task_number = 5
var total_correct_task_number = 10

var incorrect_task_number = 5
var correct_task_number = 10
var do_task_correctly = []

# list of tasks that require doing
var to_do = []
var tasks_accomplished = 0
var tasks_failed = 0

var score_text = "Done!
Correctly done tasks: %s / %s
Tasks failed: %s / %s
Time taken: %s seconds"

var speed_modifier = 1.0
var tween

var total_time = 0.0
var is_paused = false

func _ready():
    for _x in incorrect_task_number:
        do_task_correctly.append(false)
    for _x in correct_task_number:
        do_task_correctly.append(true)
    do_task_correctly.shuffle()

func _process(delta: float):
    total_time += delta
    var red_bias = 1 - speed_modifier
    red_bias = 0.5 if red_bias > 0.4 else pow(red_bias, 3)
    get_node("Blur/CanvasLayer2/ColorRect").material.set_shader_parameter("red_bias", red_bias)

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
        if event.pressed and event.keycode == KEY_ENTER:
            get_tree().reload_current_scene()
        
func get_task():
    if to_do.size() == 0:
        return Task.ComputerWork.new(self)
    return to_do.pop_front()

func add_task(task):
    to_do.append(task)

func task_finished(was_correct):
    if was_correct:
        tasks_accomplished += 1
    else:
        tasks_failed += 1
        speed_modifier = 0.5
        if tween != null:
            tween.kill()
        tween = create_tween()
        tween.tween_property(self, "speed_modifier", 1.0, 5)
    if tasks_accomplished + tasks_failed == total_correct_task_number + total_incorrect_task_number:
        get_node("Score").text = score_text % [str(tasks_accomplished), str(total_correct_task_number + total_incorrect_task_number), str(tasks_failed), str(total_incorrect_task_number), str(round(total_time))]