extends AudioStreamPlayer

@export var volume_db_start = -30
@export var volume_db_max = -10

func _ready():
    volume_db = -30
    var tween = create_tween()
    tween.tween_property(self, "volume_db", volume_db_max, 3)
