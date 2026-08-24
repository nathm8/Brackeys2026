extends Sprite2D

# stay this far away from the edge of the office
const spawn_margin = 100

func _ready():
    var office = get_tree().root.get_node("Root/Office")
    position.x = randi() % roundi(office.get_rect().size.x - spawn_margin) - office.position.x + spawn_margin
    position.y = randi() % roundi(office.get_rect().size.y - spawn_margin) - office.position.y + spawn_margin
