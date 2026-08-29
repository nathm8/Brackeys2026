class_name Ability
extends Button

const Main = preload("res://source/main.gd")

static var correction

enum AbilityType {RechargeBatteries}
var type

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	if button_pressed:
		correction = self
		# an ability and an instruction can't both be armed
		Instruction.correction = null
	else:
		correction = null
	_unpress_others()

func check_if_valid_correction(employee) -> bool:
	button_pressed = false
	if type == AbilityType.RechargeBatteries:
		# don't double up on the same employee
		if employee.current_task is Task.RechargeBattery:
			return false
		if employee.pending_task is Task.RechargeBattery:
			return false
		var main = get_tree().root.get_node("Main")
		return not main.find_children("Recharger*").is_empty()
	return false

func fix(employee):
	var main = get_tree().root.get_node("Main")
	employee.pending_task = Task.RechargeBattery.new(main)

func _unpress_others():
	var panel = get_tree().get_first_node_in_group("ui_panel")
	for button in panel.find_children("*", "Button", true, false):
		if button != self and (button is Ability or button is Instruction):
			button.button_pressed = false
