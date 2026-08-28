class_name Task

# default task to generate forms
class ComputerWork:

    var monitor_node
    static var time_to_complete = 5
    static var full_time_to_complete = 5
    var main
    var employee
    var is_correct

    func _init(m, e):
        main = m
        employee = e
        is_correct = randi() % 10 != 0

        var min_d = 1000
        var closest_monitor
        for monitor in main.find_children("Monitor?"):
            if not monitor.in_use:
                var d = employee.position.distance_to(monitor.position)
                if d < min_d:
                    min_d = d
                    closest_monitor = monitor
        monitor_node = closest_monitor
        closest_monitor.in_use = true

    func execute(delta, _e):
        var speed_modifier = main.speed_modifier * employee.speed_modifier
        if employee.position.distance_to(monitor_node.position) < 10:
            var timer = employee.get_node("Timer")
            timer.visible = true
            timer.value = time_to_complete
            timer.max_value = full_time_to_complete
            if is_correct:
                monitor_node.set_working()
                time_to_complete -= speed_modifier * delta
                if time_to_complete <= 0:
                    finish()
                    return true
            else:
                monitor_node.set_slacking()
        else:
            employee.position -= speed_modifier * delta * 100 * (employee.position - monitor_node.position).normalized()
        return false

    func finish():
        employee.get_node("Timer").visible = false
        monitor_node.in_use = false
        monitor_node.set_off()
        monitor_node = null
        time_to_complete = full_time_to_complete
        for printer in main.find_children("Printer*"):
            if not printer.is_full():
                printer.print()

enum Destination {FilingCabinet, Shredder}
enum FormType {Triangle, Square, Circle}

class FormTaskTuple:
    var form: FormType
    var target: Destination
    var is_correct: bool

class FormDelivery:

    var main
    var printer
    var form
    var destination
    var destination_type
    var time_to_complete = 1
    var picked_up = false
    var is_correct: bool

    func _init(p, m, f, tuple):
        main = m
        form = f
        printer = p
        is_correct = tuple.is_correct
        destination_type = tuple.target
        var pattern
        if tuple.target == Destination.FilingCabinet:
            pattern = "FilingCabinet*"
        else:
            pattern = "Shredder*"
        for dest in main.find_children(pattern):
            destination = dest
            break

    func execute(delta, employee):
        var speed_modifier = main.speed_modifier * employee.speed_modifier
        if not picked_up:
            if employee.global_position.distance_to(form.global_position) < 10:
                picked_up = true
                printer.form = null
                form.reparent(employee, true)
                form.create_tween().tween_property(form, "position", Vector2(10, 40), 0.2)
                form.create_tween().tween_property(form, "rotation", PI/4, 0.2)
            else:
                employee.position -= speed_modifier * delta * 100 * (employee.global_position - form.global_position).normalized()
        else:
            if employee.position.distance_to(destination.position) < 10:
                var timer = employee.get_node("Timer")
                timer.visible = true
                timer.value = time_to_complete
                timer.max_value = 1.0
                time_to_complete -= speed_modifier * delta
                if time_to_complete <= 0:
                    finish(employee)
                    return true
            else:
                employee.position -= speed_modifier * delta * 100 * (employee.position - destination.position).normalized()
        return false

    func finish(employee):
        employee.get_node("Timer").visible = false
        form.queue_free()
        main.task_finished(is_correct)
        if not is_correct:
            employee.get_node("MistakeLabel").visible = true
            var tween = employee.create_tween()
            tween.tween_interval(1)
            tween.tween_callback(func f(): employee.get_node("MistakeLabel").visible = false)
