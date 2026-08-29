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

func _button_pressed():
	if button_pressed:
		correction = self
	else:
		correction = null
	# unpress all other instruction buttons
	for instruction in get_node("..").find_children("Instruction*"):
		if (instruction != self):
			instruction.button_pressed = false
	release_focus() 

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
	if not task is Task.FormDelivery:
		return false
	# a damaged chip belongs in the recycler whatever its colour, so this
	# is checked ahead of the colour rules
	if type == InstructionType.DamagedShred:
		return task.form.damaged
	if type == InstructionType.RedInsert:
		return not task.form.damaged and task.form.type == Task.FormType.Red
	if type == InstructionType.BlueInsert:
		return not task.form.damaged and task.form.type == Task.FormType.Blue

	return false

func fix(task):
	assert(not task.is_correct, "already-correct task passed to fix()")
	task.is_correct = true
	if task is Task.FormDelivery:
		var main = get_tree().root.get_node("Main")
		task.time_to_complete = 1
		if task.form.damaged:
			task.destination_type = Task.Destination.Recycler
		elif task.form.type == Task.FormType.Red:
			task.destination_type = Task.Destination.Engineering
		else:
			task.destination_type = Task.Destination.Science
		task.destination = main.get_destination_node(task.destination_type)
