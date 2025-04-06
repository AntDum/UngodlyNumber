extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Temporarly automatically creates numbers.
	build_numbers(20)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var rng = RandomNumberGenerator.new()

func split(number: Number):
	var prime_factor_array = number.prime_factors.duplicate()
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
	childA.global_position.x = number.global_position.x + 100
	childB.global_position.y = number.global_position.x - 100
	
	number.queue_free()

func build_numbers(amount: int) -> void:
	for i in amount:
		var newNum = NumberScn.instantiate()
		newNum.randomize_value(500)
		add_child(newNum)
		newNum.global_position.x = 100 #TODO randomize spawn position.
		newNum.global_position.y = 100
		
