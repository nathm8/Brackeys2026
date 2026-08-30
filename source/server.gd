extends Node2D

enum ServerType {Engineering, Science}
@export var type: ServerType = ServerType.Science

@onready var fans = $Fans
@onready var lights = $Lights
@onready var logo = $Logo
#@onready var dead_lights = $DeadLights

const dead_light_chance = 0.25

func _ready() -> void:
	setup()

func setup() -> void:
	# modulate light colour and join the group deliveries are routed by
	if type == ServerType.Engineering:
		lights.modulate = Color.html("ff6464")
		logo.texture = preload("res://resources/spanner.svg")
		add_to_group("engineering_server")
	elif type == ServerType.Science:
		lights.modulate = Color.html("56bbff")
		logo.texture = preload("res://resources/beaker.svg")
		add_to_group("science_server")
	# hide dead lights - disabled for now
	# for child in dead_lights.get_children():
	#	child.hide()	
		
func _process(_delta: float) -> void:
	# rotate fans
	for child in fans.get_children():
		child.rotation_degrees += 12
		
#func _on_timer_timeout() -> void:
	## dead lights
	## random chance a light will dim or turn back on agani
	#for child in dead_lights.get_children():
		#if randf_range(0,1) < dead_light_chance:
			#child.show()
		#else:
			#child.hide()
