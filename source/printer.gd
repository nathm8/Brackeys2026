extends Sprite2D

var form
const Form = preload("res://source/form.gd")

var main

func _ready() -> void:
    main = get_tree().root.get_node("Main")

func is_full() -> bool:
    return form != null

# todo: parameterise this for arbitrary FormTypes and Destinations
func get_printable() -> FormTaskTuple:
    var do_correctly = main.do_task_correctly.pop_back()
    if do_correctly == null:
        return null
    var out = FormTaskTuple.new()
    out.form = [FormType.Triangle, FormType.Square].pick_random()
    out.is_correct = do_correctly
    if do_correctly:
        if out.form == FormType.Triangle:
            out.target = Destination.FilingCabinet
        else:
            out.target = Destination.Shredder
    else:
        if out.form == FormType.Triangle:
            out.target = Destination.Shredder
        else:
            out.target = Destination.FilingCabinet
    return out

func print():
    assert(not is_full(), "print() called on full printer")
    var tuple = get_printable()
    # no more jobs
    if tuple == null:
        return null
    form = Form.new(tuple.form)
    add_child(form)
    form.position.y += 190

    main.add_task(FormDeliveryTask.new(self, main, form, tuple))

enum Destination {FilingCabinet, Shredder}
enum FormType {Triangle, Square, Circle}

class FormTaskTuple:
    var form: FormType
    var target: Destination
    var is_correct: bool

class FormDeliveryTask:

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
        if not picked_up:
            if employee.global_position.distance_to(form.global_position) < 10:
                picked_up = true
                printer.form = null
                form.reparent(employee, true)
                form.create_tween().tween_property(form, "position", Vector2(0, 50), 0.2)
            else:
                employee.position -= delta * 100 * (employee.global_position - form.global_position).normalized()
        else:
            if employee.position.distance_to(destination.position) < 10:
                time_to_complete -= delta
                if time_to_complete <= 0:
                    finish()
                    return true
            else:
                employee.position -= delta * 100 * (employee.position - destination.position).normalized()
        return false

    func finish():
        form.queue_free()
        main.task_finished(is_correct)
