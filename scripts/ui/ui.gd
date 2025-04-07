extends CanvasLayer
class_name UI

@export var impie_text : String = "Erase the %d"

@onready var timer_label: Label = %TimerLabel
@onready var timer_pb: ProgressBar = %TimerPb
@onready var score_label: AnimatedLabel = %ScoreLabel
@onready var impie_label: Label = %ImpieLabel

func _ready() -> void:
	EventBus.score_updated.connect(set_score)
	EventBus.timer_updated.connect(set_time)
	EventBus.godly_updated.connect(set_impie)

func set_time(current: float, max: float) -> void:
	timer_label.text = "%s s" % str(roundf(current * 10) / 10)
	timer_pb.value = ((current / max) * 100)

func set_score(value: int) -> void:
	score_label.set_value(value)

func set_impie(value: int) -> void:
	impie_label.text = impie_text % value

func _on_button_pressed() -> void:
	EventBus.kill.emit()
