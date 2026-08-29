extends Node2D

@onready var ui_panel = get_tree().get_first_node_in_group("ui_panel")

# maintain boolean list of whether the next assigned task will be done
# correctly or not
@export var total_incorrect_task_number = 5
@export var total_correct_task_number = 10

# unlocked rules and abilities
@export var unlocked_rules: Array[String] = ["ComputerWork", "BlueInsert", "RedInsert", "DamagedShred"]
@export var unlocked_abilities: Array[String] = []

var incorrect_task_number = 5
var correct_task_number = 10
var do_task_correctly = []

# list of tasks that require doing
var to_do = []
var tasks_accomplished = 0
var tasks_failed = 0

var speed_modifier = 1.0
var tween

@export var quota_time = 150.0
var is_finalised = false

func _ready():
	correct_task_number = total_correct_task_number
	incorrect_task_number = total_incorrect_task_number
	for _x in incorrect_task_number:
		do_task_correctly.append(false)
	for _x in correct_task_number:
		do_task_correctly.append(true)
	do_task_correctly.shuffle()
	ui_panel.level_timer.max_value = quota_time
	ui_panel.level_timer.value = quota_time
	
	# configure rules panel according to unlocked rules/actions
	ui_panel.setup(unlocked_rules, unlocked_abilities)
	
func _process(_delta: float):
	# flash red if there's been a failed task
	var red_bias = 1 - speed_modifier
	red_bias = 0.5 if red_bias > 0.4 else pow(red_bias, 3)
	get_node("Blur/CanvasLayer2/ColorRect").material.set_shader_parameter("red_bias", red_bias)
	# check for game over
	if ui_panel.level_timer.value <= 0:
		finalise(false)

func _unhandled_input(event):
	if not OS.get_cmdline_args().has("debug"):
		return
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.keycode == KEY_ENTER:
			get_tree().reload_current_scene()
		
func get_task(employee):
	if to_do.size() == 0:
		return Task.ComputerWork.new(self, employee)
	return to_do.pop_front()

func add_task(task):
	to_do.append(task)

func add_task_front_queue(task):
	to_do.push_front(task)
	
# single place mapping a Destination to the node deliveries walk to
func get_destination_node(destination_type):
	var node
	match destination_type:
		Task.Destination.Engineering:
			node = get_tree().get_first_node_in_group("engineering_server")
		Task.Destination.Science:
			node = get_tree().get_first_node_in_group("science_server")
		Task.Destination.Recycler:
			node = get_tree().get_first_node_in_group("recycler")
	if node == null:
		push_error("no node found for destination %s - this level is missing a server or recycler" % destination_type)
	return node

func task_finished(was_correct, count = true):
	if was_correct and count:
		tasks_accomplished += 1
	else:
		if count:
			tasks_failed += 1
		speed_modifier = 0.5
		if tween != null:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "speed_modifier", 1.0, 5)
	if tasks_accomplished + tasks_failed == total_correct_task_number + total_incorrect_task_number:
		finalise(true)

func finalise(win):
	if is_finalised:
		return
	is_finalised = true
	ui_panel.level_timer.paused = true
	# disable blur
	get_node("Blur/CanvasLayer/ColorRect").material.set_shader_parameter("enabled", false)
	get_node("Blur/CanvasLayer2/ColorRect").material.set_shader_parameter("enabled", false)
	get_node("Blur/CanvasLayer/ColorRect").visible = false
	get_node("Blur/CanvasLayer2/ColorRect").visible = false
	# show score
	get_node("Scorescreen").visible = true
	var blurb
	if win:
		get_node("Scorescreen/Button").text = "Next Level"
		# todo: load next scene
		get_node("Scorescreen/Button").pressed.connect(func f(): get_tree().change_scene_to_file("res://scenes/interstitial1.tscn"))
		blurb = "Quota met!"
	else:
		get_node("Scorescreen/Button").text = "Try Again"
		get_node("Scorescreen/Button").pressed.connect(func f(): get_tree().reload_current_scene())
		blurb = "Quota not met"

	get_node("Scorescreen/Text").text = get_node("Scorescreen/Text").text % [
		blurb,
		str(tasks_accomplished),
		str(total_correct_task_number + total_incorrect_task_number),
		str(tasks_failed),
		str(total_incorrect_task_number),
		str(quota_time - round(ui_panel.level_timer.value)),
		str(round(quota_time))
	]
	
func battery_charged():
	ui_panel.update_battery_display("charged")

func battery_depleted():
	ui_panel.update_battery_display("depleted")
