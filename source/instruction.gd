extends Button

const Main = preload("res://source/main.gd")
const Printer = preload("res://source/printer.gd")

static var correction

# todo: generalise into some sort of verb-noun conjugation, with associated
# correct and incorrect tasks
enum InstructionType {ComputerWork, TriangleFile, SquareShred}
var type

func _ready():
    pressed.connect(_button_pressed)
    if text == "Work on Computer":
        type = InstructionType.ComputerWork
    if text == "File Triangle Forms":
        type = InstructionType.TriangleFile
    if text == "Shred Square Forms":
        type = InstructionType.SquareShred

func _button_pressed():
    if button_pressed:
        correction = self
    else:
        correction = null

# i.e. check if we're issuing the right sort of correction. Returns
# false if the task was already correct, or if we've issued a nonsense
# correction
func check_if_valid_correction(task) -> bool:
    # untoggle the button
    button_pressed = false
    # shortcut to simplify below logic
    if task.is_correct:
        return false

    if type == InstructionType.ComputerWork:
        return task is Main.ComputerWorkTask
    # FormDeliveryTask only considered corrected based on the destination
    if type == InstructionType.TriangleFile:
        return (task is Printer.FormDeliveryTask and
               task.form.type == Printer.FormType.Triangle and
               task.destination_type == Printer.Destination.Shredder)
    if type == InstructionType.SquareShred:
        return (task is Printer.FormDeliveryTask and
               task.form.type == Printer.FormType.Square and
               task.destination_type == Printer.Destination.FilingCabinet)
    
    return false

func fix(task):
    assert(not task.is_correct, "already-correct task passed to fix()")
    task.is_correct = true
    if task is Main.ComputerWorkTask:
        # todo: stop them playing solitaire
        pass
    var main = get_tree().root.get_node("Main")
    # hack: this should be specified out of our instruction type
    if task is Printer.FormDeliveryTask:
        if task.form.type == Printer.FormType.Triangle:
            for dest in main.find_children("FilingCabinet*"):
                task.destination = dest
                break
            task.destination_type = Printer.Destination.FilingCabinet
        else:
            for dest in main.find_children("Shredder*"):
                task.destination = dest
                break
            task.destination_type = Printer.Destination.Shredder
