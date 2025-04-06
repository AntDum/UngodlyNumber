extends CharacterBody2D
class_name Number

@export var speed = 100
@export var speed_following = 250
@export var min_change_direction_time = 1.5
@export var max_change_direction_time = 3.0
@export var min_idle_time = 0.5
@export var max_idle_time = 2.0

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var change_direction_time = 1.0
var idle_time = 0.5
var is_idle := false

var direction = Vector2.ZERO
var time_since_change = 0.0

var prime_factors = []
var value = 1

var rng = RandomNumberGenerator.new()

var is_ungodly = false
var is_selected = false

const raw_primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997]
var prime_weight : PackedFloat32Array = [0.5, 0.3333333333333333, 0.2, 0.14285714285714285, 0.09090909090909091, 0.07692307692307693, 0.058823529411764705, 0.05263157894736842, 0.043478260869565216, 0.034482758620689655, 0.03225806451612903, 0.02702702702702703, 0.024390243902439025, 0.023255813953488372, 0.02127659574468085, 0.018867924528301886, 0.01694915254237288, 0.01639344262295082, 0.014925373134328358, 0.014084507042253521, 0.0136986301369863, 0.012658227848101266, 0.012048192771084338, 0.011235955056179775, 0.010309278350515464, 0.009900990099009901, 0.009708737864077669, 0.009345794392523364, 0.009174311926605505, 0.008849557522123894, 0.007874015748031496, 0.007633587786259542, 0.0072992700729927005, 0.007194244604316547, 0.006711409395973154, 0.006622516556291391, 0.006369426751592357, 0.006134969325153374, 0.005988023952095809, 0.005780346820809248, 0.00558659217877095, 0.0055248618784530384, 0.005235602094240838, 0.0051813471502590676, 0.005076142131979695, 0.005025125628140704, 0.004739336492890996, 0.004484304932735426, 0.004405286343612335, 0.004366812227074236, 0.004291845493562232, 0.0041841004184100415, 0.004149377593360996, 0.00398406374501992, 0.0038910505836575876, 0.0038022813688212928, 0.0037174721189591076, 0.0036900369003690036, 0.0036101083032490976, 0.0035587188612099642, 0.0035335689045936395, 0.0034129692832764505, 0.003257328990228013, 0.003215434083601286, 0.003194888178913738, 0.0031545741324921135, 0.0030211480362537764, 0.002967359050445104, 0.002881844380403458, 0.0028653295128939827, 0.0028328611898017, 0.002785515320334262, 0.0027247956403269754, 0.002680965147453083, 0.002638522427440633, 0.0026109660574412533, 0.002570694087403599, 0.0025188916876574307, 0.0024937655860349127, 0.0024449877750611247, 0.002386634844868735, 0.0023752969121140144, 0.002320185614849188, 0.0023094688221709007, 0.002277904328018223, 0.002257336343115124, 0.0022271714922048997, 0.002188183807439825, 0.0021691973969631237, 0.0021598272138228943, 0.0021413276231263384, 0.0020876826722338203, 0.002053388090349076, 0.002036659877800407, 0.002004008016032064, 0.0019880715705765406, 0.0019646365422396855, 0.0019193857965451055, 0.0019120458891013384, 0.0018484288354898336, 0.0018281535648994515, 0.0017953321364452424, 0.0017761989342806395, 0.0017574692442882249, 0.0017513134851138354, 0.0017331022530329288, 0.0017035775127768314, 0.0016863406408094434, 0.001669449081803005, 0.0016638935108153079, 0.0016474464579901153, 0.0016313213703099511, 0.0016207455429497568, 0.0016155088852988692, 0.001584786053882726, 0.0015600624024961, 0.0015552099533437014, 0.0015455950540958269, 0.0015313935681470138, 0.0015174506828528073, 0.0015128593040847202, 0.0014858841010401188, 0.0014771048744460858, 0.0014641288433382138, 0.001447178002894356, 0.0014265335235378032, 0.0014104372355430183, 0.0013908205841446453, 0.001375515818431912, 0.001364256480218281, 0.0013531799729364006, 0.0013458950201884253, 0.0013315579227696406, 0.001321003963011889, 0.001314060446780552, 0.0013003901170351106, 0.00129366106080207, 0.0012706480304955528, 0.0012547051442910915, 0.0012360939431396785, 0.0012330456226880395, 0.001218026796589525, 0.001215066828675577, 0.0012091898428053204, 0.0012062726176115801, 0.0011918951132300357, 0.0011723329425556857, 0.0011668611435239206, 0.0011641443538998836, 0.0011587485515643105, 0.0011402508551881414, 0.0011350737797956867, 0.0011325028312570782, 0.0011273957158962795, 0.0011025358324145535, 0.0010976948408342481, 0.001088139281828074, 0.001076426264800861, 0.0010672358591248667, 0.0010626992561105207, 0.0010559662090813093, 0.001049317943336831, 0.001034126163391934, 0.0010298661174047373, 0.0010235414534288639, 0.001017293997965412, 0.0010090817356205853, 0.0010030090270812437]

func _ready() -> void:
	EventBus.selected.connect(_on_selection)
	var label_settings = LabelSettings.new()
	label_settings.font_size = 50
	label_settings.set_outline_color(Color(27, 164, 61))
	label_settings.outline_size = 0
	$Value.set_label_settings(label_settings)
	for p in raw_primes:
		prime_weight.append(1/p)
		
	_change_direction()

#region: Mouvement and drag section

func _physics_process(delta: float) -> void:
	time_since_change += delta

	if not is_selected:
		if ray_cast_2d.is_colliding() or time_since_change >= change_direction_time:
			_change_direction()
			time_since_change = 0.0
		velocity = direction * speed * delta * 60
	else:
		_follow_mouse()
		if global_position.distance_to(get_global_mouse_position()) > 50:
			velocity = direction * speed_following * delta * 60
		else:
			velocity = Vector2.ZERO
	
	
	if velocity.length() > 1:
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	move_and_slide()

func _change_direction() -> void:
	change_direction_time = rng.randf_range(min_change_direction_time, max_change_direction_time)
	idle_time = rng.randf_range(min_idle_time, max_idle_time)
	if is_idle:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		ray_cast_2d.target_position = direction * speed / 2
	else:
		direction = Vector2.ZERO
	is_idle = not is_idle

func _follow_mouse() -> void:
	direction = global_position.direction_to(get_global_mouse_position())

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			EventBus.selected.emit(self)

func _on_selection(number: Number):
	if number == self:
		_get_selected()
	else:
		_get_unselected()

func _get_selected():
	is_selected = true
	$Value.get_label_settings().outline_size = 10

func _get_unselected():
	is_selected = false
	$Value.get_label_settings().outline_size = 0

#endregion

#region: Number section

func randomize_to_ungodly(max: int, ungodly : int):
	is_ungodly = true
	value = ungodly
	prime_factors.append(ungodly)
	
	var keep_growing = true
	
	var current_primes = raw_primes.duplicate()
	current_primes.erase(ungodly)
	
	while keep_growing:
		var i = rng.rand_weighted(prime_weight)
		var new_prime = current_primes[i]
		if new_prime * value < max:
			value *= new_prime
			prime_factors.append(new_prime)
		else:
			keep_growing = false
			
	#Set value label text.
	$Value.text = str(value)
	
	#Small sanity check
	var sanity_check = 1
	for f in prime_factors:
		sanity_check *= f

	assert(sanity_check == value, "ERROR on value generation")

func randomize_to_godly(max: int, ungodly: int):
	is_ungodly = false
	value = 1
	
	var keep_growing = true
	
	var current_primes = raw_primes.duplicate()
	current_primes.erase(ungodly)
	
	while keep_growing:
		var i = rng.rand_weighted(prime_weight)
		var new_prime = current_primes[i]
		if new_prime * value < max:
			value *= new_prime
			prime_factors.append(new_prime)
		else:
			keep_growing = false
	
			
	#Set value label text.
	$Value.text = str(value)
	
	#Small sanity check
	var sanity_check = 1
	for f in prime_factors:
		sanity_check *= f

	assert(sanity_check == value, "ERROR on value generation")

func from_factors(factors: Array, is_ungodly: bool):
	self.is_ungodly = is_ungodly
	value = 1
	for f in factors:
		value *= f
		prime_factors.append(f)
	$Value.text = str(value)

#endregion:number
