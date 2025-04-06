extends Node
class_name NumberManager

var NumberScn = preload("res://scenes/number.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Temporarly automatically creates numbers.
	build_numbers(10)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func build_numbers(amount: int) -> void:
	for i in amount:
		var newNum = NumberScn.instantiate()
		newNum.randomize_value(100)
		add_child(newNum)
		newNum.global_position.x = (i/5) * 100
		newNum.global_position.y = 100 * (i%5)
