extends Node2D

func _ready():
    get_node("CanvasLayer/ColorRect").color.a = 1 if Globals.shader_enabled else 0
    get_node("CanvasLayer2/ColorRect").color.a = 1 if Globals.shader_enabled else 0
    get_node("CanvasLayer/ColorRect").material.set_shader_parameter("enabled", Globals.shader_enabled)
    get_node("CanvasLayer2/ColorRect").material.set_shader_parameter("enabled", Globals.shader_enabled)

    # normalise camera pos to [0, 1]
    var camera_pos = get_tree().root.get_node("Main/Blur/Office/Camera").global_position
    var size = get_viewport().get_visible_rect().size
    camera_pos.x /= size.x
    camera_pos.y /= size.y
    get_node("CanvasLayer/ColorRect").material.set_shader_parameter("camera_pos", camera_pos)
    get_node("CanvasLayer2/ColorRect").material.set_shader_parameter("camera_pos", camera_pos)

func _process(_delta):
    # normalise mouse pos to [0, 1]
    var mouse_pos = get_viewport().get_mouse_position()
    var size = get_viewport().get_visible_rect().size
    mouse_pos.x /= size.x
    mouse_pos.y /= size.y
    get_node("CanvasLayer/ColorRect").material.set_shader_parameter("mouse_pos", mouse_pos)
    get_node("CanvasLayer2/ColorRect").material.set_shader_parameter("mouse_pos", mouse_pos)
