class_name Task

# default task to generate forms
class ComputerWork:

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
        var speed_modifier = main.speed_modifier * employee.speed_modifier
        if employee.position.distance_to(monitor_node.position) < 10:
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
        monitor_node.in_use = false
        monitor_node.set_off()
        monitor_node = null
        time_to_complete = 1
        # todo: buffer print jobs
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
                form.create_tween().tween_property(form, "rotation", PI+PI/4, 0.2)
            else:
                employee.position -= speed_modifier * delta * 100 * (employee.global_position - form.global_position).normalized()
        else:
            if employee.position.distance_to(destination.position) < 10:
                time_to_complete -= speed_modifier * delta
                if time_to_complete <= 0:
                    finish(employee)
                    return true
            else:
                employee.position -= speed_modifier * delta * 100 * (employee.position - destination.position).normalized()
        return false

    func finish(employee):
        form.queue_free()
        main.task_finished(is_correct)
        if not is_correct:
            employee.get_node("MistakeLabel").visible = true
            var tween = employee.create_tween()
            tween.tween_interval(1)
            tween.tween_callback(func f(): employee.get_node("MistakeLabel").visible = false)
