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

func _ready():
    for _x in incorrect_task_number:
        do_task_correctly.append(false)
    for _x in correct_task_number:
        do_task_correctly.append(true)
    do_task_correctly.shuffle()

func _process(_delta: float):
    pass

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
        if event.pressed and event.keycode == KEY_ENTER:
            get_tree().reload_current_scene()
        
func get_task():
    if to_do.size() == 0:
        return ComputerWorkTask.new(self)
    return to_do.pop_front()

func add_task(task):
    to_do.append(task)

func task_finished(was_correct):
    if was_correct:
        tasks_accomplished += 1
    else:
        tasks_failed += 1

# default task to generate forms
class ComputerWorkTask:

    var monitor_node
    static var time_to_complete = 1
    var main
    var is_correct

    func _init(m):
        main = m
        is_correct = randi() % 10 != 0
        for monitor in main.find_children("Monitor?"):
            if not monitor.in_use:
                monitor_node = monitor
                monitor.in_use = true
                break

    func execute(delta, employee):
        if employee.position.distance_to(monitor_node.position) < 10:
            if is_correct:
                monitor_node.set_working()
                time_to_complete -= delta
                if time_to_complete <= 0:
                    finish()
                    return true
            else:
                monitor_node.set_slacking()
        else:
            employee.position -= delta * 100 * (employee.position - monitor_node.position).normalized()
        return false

    func finish():
        monitor_node.in_use = false
        monitor_node.set_off()
        monitor_node = null
        time_to_complete = 1
        # todo: buffer print jobs
        for printer in main.find_children("Printer*"):
            if not printer.is_full():
                printer.print()
