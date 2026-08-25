extends Sprite2D

# stay this far away from the edge of the office
const spawn_margin = 100

var current_task

func _ready():
    var office = get_tree().root.get_node("Main/Office")
    position.x = randi() % roundi(office.get_rect().size.x - spawn_margin) - office.position.x + spawn_margin
    position.y = randi() % roundi(office.get_rect().size.y - spawn_margin) - office.position.y + spawn_margin

func _process(delta: float) -> void:
    if current_task == null:
        current_task = get_tree().root.get_node("Main").get_task()
    if current_task.execute(delta, self):
        current_task = null
