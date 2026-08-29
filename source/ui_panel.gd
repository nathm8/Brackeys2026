extends Control

@onready var level_timer = %LevelTimer
@onready var rules_container = %RulesContainer
@onready var actions_container = %ActionsContainer
@onready var battery_container = %BatteryContainer

@onready var empty_battery_texture = preload("res://resources/battery_empty.svg")
@onready var charged_battery_texture = preload("res://resources/battery.svg")

@export var instruction_scene: PackedScene
@export var ability_scene: PackedScene

const MAX_BATTERIES = 4
var charged_batteries = 0

const RULE_LABELS := {
    "ComputerWork": "Work on Computer",
    "BlueInsert": "Blue Chips to Science",
    "BlueScience": "Blue Employees Order Blue Chips",
    "RedInsert": "Red Chips to Engineering",
    "DamagedShred": "Shred Damaged Chips",
    "NoCoffee": "No drinking coffee",
    "NoCoffeeExBreak": "No drinking coffee"
}

const ABILITY_LABELS := {
    "RechargeBatteries": "Recharge Batteries",
    "CraneArm": "Relocate Employee"
}

const QWERTY := [KEY_S, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y]
const NUMBERS := [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0]
        
func setup(unlocked_rules: Array[String], unlocked_abilities: Array[String]) -> void:
    # reset before loading from config
    _clear(rules_container)
    _clear(actions_container)
    
    for i in unlocked_rules.size():
        var key := unlocked_rules[i]
        assert(Instruction.InstructionType.has(key), "unknown rule: " + key)
        var button: Instruction = instruction_scene.instantiate()
        button.type = Instruction.InstructionType[key]
        button.text = "%d) %s" % [i + 1, RULE_LABELS[key]]
        button.shortcut = Shortcut.new()
        var event = InputEventKey.new()
        event.keycode = NUMBERS[i]
        button.shortcut.events = [event]
        rules_container.add_child(button)

    for i in unlocked_abilities.size():
        var key := unlocked_abilities[i]
        assert(Ability.AbilityType.has(key), "unknown ability: " + key)
        var button: Ability = ability_scene.instantiate()
        button.type = Ability.AbilityType[key]
        button.text = ABILITY_LABELS[key]
        button.shortcut = Shortcut.new()
        var event = InputEventKey.new()
        event.keycode = QWERTY[i]
        button.shortcut.events = [event]
        actions_container.add_child(button)
        
    # only display batteries if the ability is unlocked
    var has_batteries = unlocked_abilities.has("RechargeBatteries")
    battery_container.visible = has_batteries
    if has_batteries:
        charged_batteries = 2
    _refresh_battery_display()
        
func _clear(container: Node) -> void:
    for child in container.get_children():
        container.remove_child(child)
        child.queue_free()
        
func update_battery_display(battery_change):
    if battery_change == "charged":
        charged_batteries += 1
    elif battery_change == "depleted":
        charged_batteries -= 1
    charged_batteries = clampi(charged_batteries, 0, MAX_BATTERIES)
    _refresh_battery_display()

func _refresh_battery_display():
    for battery_rect in battery_container.get_children():
        if battery_rect is TextureRect:
            battery_rect.texture = charged_battery_texture if battery_rect.get_index() < charged_batteries else empty_battery_texture
