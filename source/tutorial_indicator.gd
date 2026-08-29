extends Control

func _ready():
    animate()

func animate():
    var pos_start = %TutorialArrow.position
    var pos_end   = %TutorialArrow.position + Vector2(10, 0).rotated(%TutorialArrowAnchor.global_rotation)
    var tween = create_tween()
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(%TutorialArrow, "position", pos_end, 0.5)
    tween.tween_property(%TutorialArrow, "position", pos_start, 0.5)
    tween.tween_callback(animate)
