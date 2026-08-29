extends Sprite2D

var form
const ChipScene = preload("res://scenes/form.tscn")

# proportion of printed chips that come out damaged
const FLASH_COUNT = 4
var damaged_chance = 0.3
var _flashes_left := 0

var main

# when set, the next chip printed uses these instead of being randomised.
# used by the tutorial to make its one chip deterministic.
var forced_form = null
var forced_damaged = null

@onready var light = $Light

func _ready() -> void:
	main = get_tree().root.get_node("Main")

func is_full() -> bool:
	return form != null

func get_printable():
	var do_correctly = main.do_task_correctly.pop_back()
	if do_correctly == null:
		return null
	var out = Task.FormTaskTuple.new()
	out.form = forced_form if forced_form != null else [Task.FormType.Red, Task.FormType.Blue].pick_random()
	out.damaged = forced_damaged if forced_damaged != null else randf() < damaged_chance
	out.is_correct = do_correctly
	# where this chip belongs on colour alone
	var colour_server = Task.Destination.Engineering
	var other_server = Task.Destination.Science
	if out.form == Task.FormType.Blue:
		colour_server = Task.Destination.Science
		other_server = Task.Destination.Engineering
	if out.damaged:
		# damaged chips belong in the recycler; the mistake is filing
		# them at the server they'd have gone to undamaged
		out.target = Task.Destination.Recycler if do_correctly else colour_server
	else:
		out.target = colour_server if do_correctly else other_server
	return out

func print():
	assert(not is_full(), "print() called on full printer")
	var tuple = get_printable()
	# no more jobs
	if tuple == null:
		return null
	form = ChipScene.instantiate()
	add_child(form)
	form.setup(tuple.form, tuple.damaged)
	form.position.y += 40

	main.add_task(Task.FormDelivery.new(self, main, form, tuple))
	flash()
	
func flash(times := 3):
	_flashes_left = times * 2 
	$Timer.start()

func _on_timer_timeout() -> void:
	light.visible = not light.visible
	_flashes_left -= 1
	if _flashes_left <= 0:
		$Timer.stop()
