extends CanvasLayer

@export var stat_manager: StatManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_sound_player: AudioStreamPlayer = $ClickSoundPlayer

var sound_tween : Tween

func _ready() -> void:
	EventBus.lost.connect(_on_lost)
	
func _on_lost() -> void:
	show_layout()

func _update_layout() -> void:
	sound_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	var tick = 15.0
	var delay = 1.5 / tick
	for i in range(tick):
		sound_tween.tween_callback(click_sound_player.play).set_delay(delay * i)
	%score_label.set_value(stat_manager.score)
	%ungodly_killed.set_value(stat_manager.ungodly_killed)
	%bad_killed_label.set_value(stat_manager.godly_killed)
	
func show_layout() -> void:
	animation_player.play("show")
	
func hide_layout() -> void:
	animation_player.play("hide")

func _on_retry_button_pressed() -> void:
	if sound_tween:
		sound_tween.kill()
	hide_layout()
	EventBus.retry.emit()
