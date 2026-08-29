extends Node2D

enum ServerType {Engineering, Science}
@export var type: ServerType = ServerType.Science

@onready var fans = $Fans
@onready var lights = $Lights
@onready var logo = $Logo

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

func _process(_delta: float) -> void:
	# rotate fans
	for child in fans.get_children():
		child.rotation_degrees += 12
