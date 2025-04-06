extends Node

@export var game_time : float = 30

@export var ui : UI

@onready var game_timer: Timer = $GameTimer

var is_round_running = false
var selected : Number = null

var score : int = 0: set = _setter_score

func _ready() -> void:
	SceneManager.end_transition.connect(start_game)
	EventBus.selected.connect(_on_number_selected)
	EventBus.kill.connect(_on_kill_number)

func _process(delta: float) -> void:
	if ui:
		ui.set_time(game_timer.time_left, game_time) 

func start_game() -> void:
	EventBus.game_started.emit()
	start_round()

func start_round() -> void:
	EventBus.round_started.emit()
	game_timer.start(game_time)
	is_round_running = true

func won_round() -> void:
	is_round_running = false
	print("Won round")
	pass

func lost_round() -> void:
	is_round_running = false
	print("Lost round")
	pass

func clear_game() -> void:
	game_timer.stop()

func kill_all_number() -> void:
	for number in get_tree().get_nodes_in_group("numbers"):
		number.queue_free()
		
func remaining_ungodly() -> int:
	var tot = 0
	for number in get_tree().get_nodes_in_group("numbers"):
		if number.is_ungodly:
			tot += 1
	return tot

func _on_kill_number() -> void:
	if not is_round_running: return
	EventBus.number_killed.emit(not selected.is_ungodly)
	if selected.is_ungodly:
		score += 100
	else:
		score -= 50
	selected.queue_free()
	if remaining_ungodly() == 0:
		won_round()

func _on_number_selected(number : Number) -> void:
	if not is_round_running: return
	if selected == number:
		EventBus.split.emit(number)
	else:
		print("New selection : ", number.value)
		selected = number

func _setter_score(value) -> void:
	score = value
	if ui:
		ui.set_score(value)


func _on_game_timer_timeout() -> void:
	lost_round()
