extends Node

@export var game_time : float = 30

@export var ui : UI

@onready var game_timer: Timer = $GameTimer

var selected : Number = null

var score : int = 0: set = _setter_score

func _ready() -> void:
	EventBus.selected.connect(_on_number_selected)
	start_game()

func _process(delta: float) -> void:
	if ui:
		ui.set_time(game_timer.time_left, game_time) 

func start_game() -> void:
	game_timer.start(game_time)

func clear_game() -> void:
	game_timer.stop()

func _on_number_selected(number : Number) -> void:
	pass

func _setter_score(value) -> void:
	score = value
	if ui:
		ui.set_score(value)
