extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")
@onready var ui: UI = $"../UI"

var current_ungodly

var round_number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.split.connect(_on_split)
	EventBus.round_started.connect(_on_new_round)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const ungodly_candidates = [2, 3, 5, 7, 11, 13, 17]

func _on_new_round():
	round_number += 1
	current_ungodly = ungodly_candidates.pick_random()
	build_numbers(round_number, 1, current_ungodly)
	ui.set_impie(current_ungodly)

var rng = RandomNumberGenerator.new()

func _on_split(number: Number):
	$SplitSoundPlayer.play()
	var prime_factor_array = number.prime_factors.duplicate()
	if(prime_factor_array.size() == 1): return
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
		
		add_child(newNum)
		newNum.global_position.x = rng.randi_range(0,1000) #TODO randomize spawn position.
		newNum.global_position.y = 100 + i * 150
	
	for i in amount_of_ungodly:
		var newNum = NumberScn.instantiate()
		newNum.randomize_to_ungodly(500, ungodly_number)
		
		add_child(newNum)
		newNum.global_position.x = rng.randi_range(0,1000) #TODO randomize spawn position.
		newNum.global_position.y = 100 + (i+amount_of_godly) * 150
