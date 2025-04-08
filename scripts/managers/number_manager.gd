extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")

const ungodly_candidates = [2, 3, 5, 7, 11]
var current_ungodly : int

var round_number = 0
var is_round_running = false

var rng = RandomNumberGenerator.new()
@onready var top_left: Node2D = $TopLeft
@onready var bottom_right: Node2D = $BottomRight

func _ready() -> void:
	EventBus.split.connect(_on_split)
	EventBus.kill.connect(_on_kill_number)
	EventBus.round_started.connect(_on_new_round)
	EventBus.round_ended.connect(_on_round_cleared)
	EventBus.game_started.connect(_on_game_started)
	EventBus.round_anouncement_finished.connect(_on_announcement_finished)

func _on_game_started():
	round_number = 0

func _on_new_round():
	round_number += 1
	is_round_running = true
	_select_new_ungodly()

func _on_round_cleared():
	is_round_running = false

func _on_announcement_finished() -> void:
	var amount_of_number = 2 + roundi(round_number / 3.0)
	var max_value = 500 + (100 * round_number)
	build_numbers(amount_of_number, 1, current_ungodly, max_value)

func _select_new_ungodly() -> void:
	current_ungodly = ungodly_candidates.pick_random()
	EventBus.godly_updated.emit(current_ungodly)

func _on_kill_number(number: Number):
	if not is_round_running: return
	$OnKillSoundPlayer.play()
	var is_ungodly = number.number.is_ungodly
	number.kill()
	EventBus.number_killed.emit(not is_ungodly)

func _on_split(number: Number):
	if not number.number.can_split(): 
		$NotSplitSoundPlayer.play()
		return
	$SplitSoundPlayer.play()

	var childA: Number = NumberScn.instantiate()
	var childB: Number = NumberScn.instantiate()
	
	var newNumbers = number.number.split()
	childA.set_number(newNumbers[0])
	childB.set_number(newNumbers[1])
	
	add_child(childA)
	add_child(childB)
	childA.global_position.x = number.global_position.x + 35
	childA.global_position.y = number.global_position.y
	childB.global_position.x = number.global_position.x - 35
	childB.global_position.y = number.global_position.y
	
	number.kill()

func build_numbers(amount_of_godly: int, amount_of_ungodly: int, ungodly_number: int, max_value: int) -> void:
	for i in amount_of_godly:
		_build_number(max_value, ungodly_number, false)
	
	for i in amount_of_ungodly:
		_build_number(max_value, ungodly_number, true)

func _build_number(max_number : int, ungodly_number : int, ungoldy : bool) -> void:
	var newNum : Number = NumberScn.instantiate()
	
	var number : GodlyNumber = GodlyNumber.new(ungodly_number)
	number._randomize(max_number, ungoldy)
		
	add_child(newNum)
	newNum.set_number(number)
	newNum.global_position = _get_random_position()

func _get_random_position() -> Vector2:
	return Vector2(rng.randf_range(top_left.global_position.x, bottom_right.global_position.x),
					rng.randf_range(top_left.global_position.y, bottom_right.global_position.y))

	 
