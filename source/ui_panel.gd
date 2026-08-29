extends Control

@onready var level_timer = %LevelTimer
@onready var rules_container = %RulesContainer
@onready var actions_container = %ActionsContainer

@export var instruction_scene: PackedScene
@export var ability_scene: PackedScene

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
		rules_container.add_child(button)

	for key in unlocked_abilities:
		assert(Ability.AbilityType.has(key), "unknown ability: " + key)
		var button: Ability = ability_scene.instantiate()
		button.type = Ability.AbilityType[key]
		button.text = ABILITY_LABELS[key]
		actions_container.add_child(button)
		
func _clear(container: Node) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
		
