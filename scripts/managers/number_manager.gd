extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")

const ungodly_candidates = [2, 3, 5, 7, 11, 13, 17]
var current_ungodly : int

var round_number = 0

var rng = RandomNumberGenerator.new()
@onready var top_left: Node2D = $TopLeft
@onready var bottom_right: Node2D = $BottomRight

func _ready() -> void:
	EventBus.split.connect(_on_split)
	EventBus.round_started.connect(_on_new_round)
	EventBus.game_started.connect(_on_game_started)

func _on_game_started():
	round_number = 0

func _on_new_round():
	round_number += 1
	current_ungodly = ungodly_candidates.pick_random()
	build_numbers(round_number, 1, current_ungodly)
	EventBus.godly_updated.emit(current_ungodly)


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
	
	number.queue_free()

func build_numbers(amount_of_godly: int, amount_of_ungodly: int, ungodly_number: int) -> void:
	for i in amount_of_godly:
		_build_number(500, ungodly_number, false)
	
	for i in amount_of_ungodly:
		_build_number(500, ungodly_number, true)

func _build_number(max_number : int, ungodly_number : int, ungoldy : bool) -> void:
	var newNum : Number = NumberScn.instantiate()
	
	var number : GodlyNumber = GodlyNumber.new(ungodly_number)
	number._randomize(max_number, ungoldy)
	newNum.set_number(number)
		
	add_child(newNum)
	newNum.global_position = _get_random_position()

func _get_random_position() -> Vector2:
	return Vector2(rng.randf_range(top_left.global_position.x, bottom_right.global_position.x),
					rng.randf_range(top_left.global_position.y, bottom_right.global_position.y))

	 
