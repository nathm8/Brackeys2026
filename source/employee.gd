extends Sprite2D

const Instruction = preload("res://source/instruction.gd")

# stay this far away from the edge of the office
const spawn_margin = 100

var current_task
var speed_modifier = 1.0
var face

var default_face = "´～`"
var happy_faces = ["⊙ω⊙", "•ิ_•ิ", "¬‿¬"]
var angry_faces = ["ಠ_ಠ", "⌣̀_⌣́", "╥﹏╥"]

func _ready():
    var office = get_tree().root.get_node("Main/Office")
    position.x = randi() % roundi(office.get_rect().size.x - spawn_margin) - office.position.x + spawn_margin
    position.y = randi() % roundi(office.get_rect().size.y - spawn_margin) - office.position.y + spawn_margin

    # have the area2D child call our input_event
    get_node("Area2D").input_event.connect(func(_v, e, _s): input_event(e))

func _process(delta: float) -> void:
    if current_task == null:
        current_task = get_tree().root.get_node("Main").get_task()
    if current_task.execute(delta, self):
        current_task = null

func input_event(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            if Instruction.correction != null and current_task != null:
                var correct = Instruction.correction.check_if_valid_correction(current_task)
                var face = get_node("Face")
                if correct:
                    Instruction.correction.fix(current_task)
                    # show surprise, speed up
                    face.text = happy_faces.pick_random()
                    speed_modifier += 0.5
                    var tween = create_tween()
                    tween.tween_property(self, "speed_modifier", 1.0, 5)
                    tween.tween_callback(func f(): face.text = default_face)
                else:
                    # show anger or confusion, stop for awhile
                    speed_modifier = 0.0
                    face.text = angry_faces.pick_random()
                    var tween = create_tween()
                    tween.tween_property(self, "speed_modifier", 1.0, 5)
                    tween.tween_callback(func f(): face.text = default_face)
                Instruction.correction = null
