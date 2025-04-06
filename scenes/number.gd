extends Node2D
class_name Number


var prime_factors = []
var value = 1

const raw_primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997]

func _ready() -> void:
	pass
	
func _process(delta : float) -> void:
	pass

var rng = RandomNumberGenerator.new()

func randomize_value(max: int):
	value = rng.randi_range(2,max)
	
	# Identify prime factors
	var reduced_value = value
	var i = 0
	while reduced_value != 1 and reduced_value >= raw_primes[i]:
		if(reduced_value % raw_primes[i] == 0):
			prime_factors.append(raw_primes[i])
			reduced_value = int(reduced_value / raw_primes[i])
		else:
			i += 1
			
	#Set value label text.
	$Value.text = str(value)
	
	#Small sanity check
	var sanity_check = 1
	for f in prime_factors:
		sanity_check *= f
	assert(sanity_check == value, "ERROR on value generation")
	


func from_factors(factors: Array):
	value = 1
	for f in factors:
		value *= f
		prime_factors.append(f)
