extends Node2D

# changed to global class, no longer loading in employee scene
#const Instruction = preload("res://source/instruction.gd")
#const Ability = preload("res://source/ability.gd")

var current_task
var pending_task
var speed_modifier = 1.0
var face
var default_face

var previous_x = 0

static var default_faces = ["´~`", "•_•", " '-'"]
static var happy_faces = ["⊙ω⊙", "¬‿¬", "„• ֊ •„", ">ᴗ<", "˘ᵕ˘"]
static var angry_faces = ["≖_≖", "⌣̀_⌣́", "╥‸╥", "•ิ_•ิ", "¬`‸´¬"]

func _ready():
    position.x += randi() % 400 - 200
    position.y += randi() % 400 - 200

    # init face and skin tone
    default_face = default_faces.pick_random()
    face = get_node("EmployeeHead/Face")
    face.text = default_face
    get_node("EmployeeHead").self_modulate = Globals.skin_tones.pick_random()
    # pick a body
    var bodies = [1, 2]
    bodies.shuffle()
    var body = get_node("EmployeeBody%s" % bodies[0])
    body.self_modulate = get_node("EmployeeHead").self_modulate
    get_node("EmployeeBody%s" % bodies[1]).visible = false
    # disable clothing for now
    get_node("ManagerHat").visible = false
    for vest in find_children("UnionVest*"):
        vest.visible = false

    # have the area2D child call our input_event
    get_node("Area2D").input_event.connect(func(_v, e, _s): input_event(e))

func _process(delta):
    if current_task == null:
        if pending_task != null:
            current_task = pending_task
            pending_task = null
        else:
            current_task = get_tree().root.get_node("Main").get_task(self)
    if current_task.execute(delta, self):
        current_task = null
    # directionality
    if position.x < previous_x:
        get_node("EmployeeHead").scale = Vector2(-1, 1)
    elif position.x > previous_x:
        get_node("EmployeeHead").scale = Vector2(1, 1)
    previous_x = position.x

func input_event(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            if Instruction.correction != null and current_task != null:
                var correct = Instruction.correction.check_if_valid_correction(current_task)
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
            # dodgy, but just replcating logic for speediness
            elif Ability.correction != null and current_task != null:
                var correct = Ability.correction.check_if_valid_correction(self)
                if correct:
                    Ability.correction.fix(self)
                    # acknowledge the order
                    face.text = happy_faces.pick_random()
                    var tween = create_tween()
                    tween.tween_interval(1)
                    tween.tween_callback(func f(): face.text = default_face)
                else:
                    # show anger or confusion, stop for awhile
                    speed_modifier = 0.0
                    face.text = angry_faces.pick_random()
                    var tween = create_tween()
                    tween.tween_property(self, "speed_modifier", 1.0, 5)
                    tween.tween_callback(func f(): face.text = default_face)
                Ability.correction = null
