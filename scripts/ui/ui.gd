extends CanvasLayer
class_name UI

@export var impie_text : String = "Erase the %d"

@onready var timer_label: Label = %TimerLabel
@onready var timer_pb: ProgressBar = %TimerPb
@onready var score_label: AnimatedLabel = %ScoreLabel
@onready var impie_label: Label = %ImpieLabel

var current_time : float = 0.0
var max_time : float = 0.0

func _ready() -> void:
	EventBus.score_updated.connect(set_score)
	EventBus.timer_updated.connect(set_time)
	EventBus.godly_updated.connect(set_impie)
	EventBus.round_ended.connect(_on_round_ended)
	EventBus.round_started.connect(_on_round_started)

func _on_round_ended() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(_update_time, current_time, 0.0, 1.0)
	tween.tween_callback(_round_closure_finished)

func _on_round_started() -> void:
	$AnimationPlayer.play("annouce_round")

func _round_closure_finished() -> void:
	EventBus.round_closure_finished.emit()

func _round_announcement_finished() -> void:
	EventBus.round_anouncement_finished.emit()

func set_time(current: float, max: float) -> void:
	max_time = max
	current_time = current
	_update_time(current_time)

func _update_time(current: float) -> void:
	var rounded_time = roundf(current * 10) / 10
	timer_label.text = "%s s" % str(rounded_time)
	timer_pb.value = ((rounded_time / max_time) * 100)

func set_score(value: int) -> void:
	score_label.set_value(value)

func set_impie(value: int) -> void:
	impie_label.text = impie_text % value

func _on_button_pressed() -> void:
	EventBus.kill.emit()
