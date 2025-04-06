extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.split.connect(_on_split)
	build_numbers(2, 4, 3)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var rng = RandomNumberGenerator.new()

func _on_split(number: Number):
	var prime_factor_array = number.prime_factors.duplicate()
	if(prime_factor_array.size() == 1): return
	prime_factor_array.shuffle()
	var childA = NumberScn.instantiate()
	var childB = NumberScn.instantiate()
	
	var pivot = rng.randi_range(1, prime_factor_array.size()-1)
	print("Pivot on %s (%s)" % [pivot, prime_factor_array])
	childA.from_factors(prime_factor_array.slice(0, pivot))
	childB.from_factors(prime_factor_array.slice(pivot))
	
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
