extends Node
class_name StatManager

var killed = 0
var ungodly_killed = 0
var godly_killed = 0
var round_played = 0

func _ready() -> void:
	EventBus.number_killed.connect(_on_number_killed)
	EventBus.game_started.connect(_on_game_started)
	EventBus.round_started.connect(_on_round_started)
	
func _on_number_killed(is_godly : bool) -> void:
	killed += 1
	if is_godly:
		godly_killed += 1
	else:
		ungodly_killed += 1

func _on_game_started() -> void:
	killed = 0
	ungodly_killed = 0
	godly_killed = 0
	round_played = 0
	
func _on_round_started() -> void:
	round_played += 1
