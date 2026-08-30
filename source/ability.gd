class_name Ability
extends Button

const Main = preload("res://source/main.gd")
const SpeedUpSensor = preload("res://scenes/speedup_sensor.tscn")

@onready var ui_panel = get_tree().get_first_node_in_group("ui_panel")

static var correction

enum AbilityType {RechargeBatteries, SpeedUp}
var type

func _ready():
    pressed.connect(_button_pressed)

func _button_pressed():
    if button_pressed:
        if type == AbilityType.SpeedUp:
            if ui_panel.charged_batteries > 0:
                ui_panel.update_battery_display("depleted")
                disabled = true
                var speedup = SpeedUpSensor.instantiate()
                get_tree().root.add_child(speedup)
                # unpress button after speedup runs out
                var tween = create_tween()
                tween.tween_interval(speedup.total_lifetime)
                tween.tween_callback(func f(): button_pressed = false; disabled = false)
            else:
                button_pressed = false
        else:
            correction = self
            # an ability and an instruction can't both be armed
            Instruction.correction = null
    else:
        correction = null
    _unpress_others()
    release_focus() 

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
