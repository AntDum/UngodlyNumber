extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")
@export var ui : UI

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
	ui.set_impie(current_ungodly)


func _on_split(number: Number):
	var prime_factor_array = number.prime_factors.duplicate()
	if(prime_factor_array.size() == 1): 
		$NotSplitSoundPlayer.play()
		return
	$SplitSoundPlayer.play()

	prime_factor_array.shuffle()
	var childA = NumberScn.instantiate()
	var childB = NumberScn.instantiate()
	
	var pivot = rng.randi_range(1, prime_factor_array.size()-1)
	print("Pivot on %s (%s)" % [pivot, prime_factor_array])
	var childA_factors = prime_factor_array.slice(0, pivot)
	var childB_factors = prime_factor_array.slice(pivot)
	childA.from_factors(childA_factors, current_ungodly in childA_factors)
	childB.from_factors(childB_factors, current_ungodly in childB_factors)
	
	print("Generated %s and %s from %s" % [childA.value, childB.value, number.value])

	add_child(childA)
	add_child(childB)
	childA.global_position.x = number.global_position.x + 35
	childA.global_position.y = number.global_position.y
	childB.global_position.x = number.global_position.x - 35
	childB.global_position.y = number.global_position.y
	
	number.queue_free()

func build_numbers(amount_of_godly: int, amount_of_ungodly: int, ungodly_number: int) -> void:
	for i in amount_of_godly:
		var newNum = NumberScn.instantiate()
		newNum.randomize_to_godly(500, ungodly_number)
		
		_add_child_random(newNum)
	
	for i in amount_of_ungodly:
		var newNum = NumberScn.instantiate()
		newNum.randomize_to_ungodly(500, ungodly_number)
		
		_add_child_random(newNum)

func _add_child_random(node: Node2D) -> void:
	add_child(node)
	node.global_position.x = rng.randf_range(top_left.global_position.x, bottom_right.global_position.x)
	node.global_position.y = rng.randf_range(top_left.global_position.y, bottom_right.global_position.y)
