extends Node2D

var total_lifetime = 10
var lifetime
var dying = false

func _ready():
    get_node("Sprite/Area2D").area_entered.connect(speedup)
    get_node("Sprite/Area2D").area_exited.connect(slowdown)
    lifetime = total_lifetime
    scale = Vector2(0, 0)
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2(1,1), 0.5)

func _process(delta):
    position = get_viewport().get_mouse_position() + Vector2(0, 10)
    lifetime -= delta
    # modulate.a = 0.1 * lifetime/total_lifetime
    if lifetime <= 0.2 * total_lifetime and not dying:
        dying = true
        var tween = create_tween()
        tween.tween_property(self, "scale", Vector2(0,0), 0.2 * total_lifetime)
    if lifetime <= 0:
        queue_free()

func speedup(area: Area2D):
    # employees are the only nodes with area
    var employee = area.get_node("..")
    employee.get_watched_speedup()

func slowdown(area: Area2D):
    # employees are the only nodes with area
    var employee = area.get_node("..")
    employee.lose_watched_speedup()
