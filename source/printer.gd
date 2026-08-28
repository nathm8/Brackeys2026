extends Sprite2D

var form
const Form = preload("res://source/form.gd")

var main

func _ready() -> void:
    main = get_tree().root.get_node("Main")

func is_full() -> bool:
    return form != null

# todo: parameterise this for arbitrary FormTypes and Destinations
func get_printable():
    var do_correctly = main.do_task_correctly.pop_back()
    if do_correctly == null:
        return null
    var out = Task.FormTaskTuple.new()
    out.form = [Task.FormType.Triangle, Task.FormType.Square].pick_random()
    out.is_correct = do_correctly
    if do_correctly:
        if out.form == Task.FormType.Triangle:
            out.target = Task.Destination.FilingCabinet
        else:
            out.target = Task.Destination.Shredder
    else:
        if out.form == Task.FormType.Triangle:
            out.target = Task.Destination.Shredder
        else:
            out.target = Task.Destination.FilingCabinet
    return out

func print():
    assert(not is_full(), "print() called on full printer")
    var tuple = get_printable()
    # no more jobs
    if tuple == null:
        return null
    form = Form.new(tuple.form)
    add_child(form)
    form.position.y += 40

    main.add_task(Task.FormDelivery.new(self, main, form, tuple))