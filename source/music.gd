extends AudioStreamPlayer

@export var volume_db_inaudible = -50
@export var volume_db_max = -10
@export var fade_time = 3
var tween
var enabled = true:
    set(e):
        enabled = e
        playing = enabled
    get:
        return enabled
const menu_music = preload("res://sound/menu.ogg")
const level_music = preload("res://sound/play.ogg")

func _ready():
    play_stream(menu_music)

func set_volume(v):
    if tween.is_running():
        tween.kill()
    volume_db = v
    volume_db_max = v

func fade_in():
    volume_db = volume_db_inaudible
    if tween != null and tween.is_running():
        tween.kill()
    tween = create_tween()
    tween.tween_property(self, "volume_db", volume_db_max, fade_time)

func fade_out():
    if tween.is_running():
        tween.kill()
    tween = create_tween()
    tween.tween_property(self, "volume_db", volume_db_inaudible, fade_time)

# default starting music
func play_stream(audio_stream):
    stream = audio_stream
    playing = true
    fade_in()

func queue_stream(audio_stream):
    if !enabled:
        return
    fade_out()
    tween.tween_callback(func f(): play_stream(audio_stream))

func play_menu_music():
    queue_stream(menu_music)

func play_level_music():
    queue_stream(level_music)
