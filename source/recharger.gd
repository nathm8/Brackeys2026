extends Sprite2D

var in_use = false

@onready var crank = $Crank

func _process(delta: float) -> void:
	if in_use:
		# animate crank
		crank.rotation_degrees += 2
