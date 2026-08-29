class_name Instruction
extends Button

const Main = preload("res://source/main.gd")

static var correction

# todo: generalise into some sort of verb-noun conjugation, with associated
# correct and incorrect tasks
enum InstructionType {ComputerWork, BlueInsert, RedInsert, DamagedShred}
var type

func _ready():
	pressed.connect(_button_pressed)
	#if text == "1) Work on Computer":
		#type = InstructionType.ComputerWork
	#if text == "2) File Triangle Forms":
		#type = InstructionType.BlueInsert
	#if text == "3) Shred Square Forms":
		#type = InstructionType.DamagedShred

func _button_pressed():
	if button_pressed:
		correction = self
	else:
		correction = null
	# unpress all other instruction buttons
	for instruction in get_node("..").find_children("Instruction*"):
		if (instruction != self):
			instruction.button_pressed = false

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
		return task is Task.ComputerWork
	# FormDeliveryTask only considered corrected based on the destination
	if type == InstructionType.BlueInsert:
		return (task is Task.FormDelivery and
			   task.form.type == Task.FormType.Triangle and
			   task.destination_type == Task.Destination.Shredder)
	if type == InstructionType.DamagedShred:
		return (task is Task.FormDelivery and
			   task.form.type == Task.FormType.Square and
			   task.destination_type == Task.Destination.FilingCabinet)
	
	return false

func fix(task):
	assert(not task.is_correct, "already-correct task passed to fix()")
	task.is_correct = true
	if task is Task.ComputerWork:
		pass
	var main = get_tree().root.get_node("Main")
	# hack: this should be specified out of our instruction type
	if task is Task.FormDelivery:
		task.time_to_complete = 1
		if task.form.type == Task.FormType.Triangle:
			for dest in main.find_children("FilingCabinet*"):
				task.destination = dest
				break
			task.destination_type = Task.Destination.FilingCabinet
		else:
			for dest in main.find_children("Shredder*"):
				task.destination = dest
				break
			task.destination_type = Task.Destination.Shredder
