extends Sprite2D

var type
var damaged = false

# called by the printer once the scene has been instantiated, since a
# scene root can't take constructor arguments
func setup(chip_type, is_damaged) -> void:
	type = chip_type
	damaged = is_damaged
	if type == Task.FormType.Blue:
		texture = preload("res://resources/blue_chip.svg")
	elif type == Task.FormType.Red:
		texture = preload("res://resources/red_chip.svg")
	$Damage.visible = damaged
