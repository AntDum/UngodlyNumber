extends CanvasLayer
class_name UI

@export var impie_text : String = "Erase the %d"

@onready var timer_label: Label = %TimerLabel
@onready var timer_pb: ProgressBar = %TimerPb
@onready var score_label: AnimatedLabel = %ScoreLabel
@onready var impie_label: Label = %ImpieLabel

@onready var bottom_container: MarginContainer = $BottomContainer
@onready var timer_ap: AnimationPlayer = $TimerAP

@onready var click_sound_player: AudioStreamPlayer = $ClickSoundPlayer

var current_time : float = 0.0
var max_time : float = 0.0

var ungodly_number : int = 0

var first_round = true
var round_end_lock = false

func _ready() -> void:
	EventBus.score_updated.connect(set_score)
	EventBus.timer_updated.connect(set_time)
	EventBus.godly_updated.connect(set_impie)
	EventBus.round_ended.connect(_on_round_ended)
	EventBus.round_started.connect(_on_round_started)
	

func _on_round_ended() -> void:
	round_end_lock = true
	var total_time = 1.0
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_method(_update_time, current_time, 0.0, total_time)
	var tick = 10.0
	var delay = 1.0 / tick
	for i in range(tick):
		tween.tween_callback(click_sound_player.play).set_delay(delay * i)
	tween.tween_callback(_round_closure_finished).set_delay(total_time)
	tween.tween_callback(func(): round_end_lock = false).set_delay(total_time)

func _on_round_started() -> void:
	$AnimationPlayer.play("annouce_round")
	if first_round:
		first_round = false
	else:
		var tween = create_tween()
		tween.tween_method(_update_time, 0.0, max_time, 0.7).set_delay(1.8)
	

func _round_closure_finished() -> void:
	EventBus.round_closure_finished.emit()

func _round_announcement_finished() -> void:
	EventBus.round_anouncement_finished.emit()

func set_time(current: float, maximum: float) -> void:
	max_time = maximum
	current_time = current
	_update_time(current_time)

func _update_time(current: float) -> void:
	var rounded_time = roundf(current * 10) / 10
	timer_label.text = "%s s" % str(rounded_time)
	timer_pb.value = ((rounded_time / max_time) * 100)
	if round_end_lock or timer_pb.value >= 15 or timer_pb.value <= 0.1:
		timer_ap.play("RESET")
	elif not timer_ap.is_playing():
		timer_ap.play("shake")

func set_score(value: int) -> void:
	score_label.set_value(value)

func set_impie(value: int) -> void:
	ungodly_number = value

func _update_ungodly() -> void:
	impie_label.text = impie_text % ungodly_number
