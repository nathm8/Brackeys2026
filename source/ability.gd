class_name Ability
extends Button

const Main = preload("res://source/main.gd")

static var correction

# todo: generalise into some sort of verb-noun conjugation, with associated
# correct and incorrect tasks
enum AbilityType {RechargeBatteries}
var type

func _ready():
	pressed.connect(_button_pressed)

func _button_pressed():
	print("ability button pressed")
