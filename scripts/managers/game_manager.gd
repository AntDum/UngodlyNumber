extends Node
class_name GameManager

@export var game_time : float = 10
@export var kill_score: int = 100
@export var kill_penalty: int = 200

@onready var game_timer: Timer = $GameTimer

var is_round_running = false

var score : int = 0: set = _setter_score

func _ready() -> void:
	SceneManager.end_transition.connect(start_game)
	EventBus.number_killed.connect(_on_number_killed)
	EventBus.retry.connect(start_game)
	EventBus.round_anouncement_finished.connect(_on_round_announcement_finished)
	EventBus.round_closure_finished.connect(start_round)

func _process(_delta: float) -> void:
	if is_round_running:
		EventBus.timer_updated.emit(game_timer.time_left, game_time)

func start_game() -> void:
	EventBus.game_started.emit()
	score = 0
	start_round()

func retry() -> void:
	EventBus.game_started.emit()
	score = 0

func start_round() -> void:
	EventBus.round_started.emit()

func _on_round_announcement_finished() -> void:
	game_timer.start(game_time)
	is_round_running = true

func end_round() -> void:
	is_round_running = false
	score += roundi(game_timer.time_left) * 10
	game_timer.stop()
	kill_all_number()

func won_round() -> void:
	$RoundWonSoundPlayer.play()
	end_round()
	EventBus.round_ended.emit()

func lost_round() -> void:
	$RoundLostSoundPlayer.play()
	end_round()
	EventBus.lost.emit()

func clear_game() -> void:
	game_timer.stop()

func kill_all_number() -> void:
	var tween = create_tween().set_parallel(true)
	for number:Number in get_tree().get_nodes_in_group("numbers"):
		if number.number.is_ungodly:
			number.illuminate()
		else:
			tween.tween_callback(number.kill).set_delay(randf_range(0.1, 0.5))
		
func remaining_ungodly() -> int:
	var tot = 0
	for number:Number in get_tree().get_nodes_in_group("numbers"):
		if number.number.is_ungodly and not number.killed:
			tot += 1
	return tot

func _on_number_killed(is_godly: bool) -> void:
	if not is_round_running: return
	if not is_godly:
		score += kill_score
	else:
		score -= kill_penalty
		
	if remaining_ungodly() == 0:
		won_round()

func _setter_score(value) -> void:
	score = value
	EventBus.score_updated.emit(value)

func _on_game_timer_timeout() -> void:
	lost_round()
