extends CanvasLayer

@export var dead_time : float = 0.2 
var _currently_loading : bool = false
var _scene_to_load : String = ""

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func swap_scene(to: String) -> void:
	if _currently_loading: return
	if not ResourceLoader.exists(to): return
	_scene_to_load = to
	_start_transition()

func _start_transition() -> void:
	_currently_loading = true
	animation_player.play("ripple_in")
	
func _transition() -> void:
	get_tree().change_scene_to_file(_scene_to_load)

func _end_transition() -> void:
	_currently_loading = false

func _finished_fade_in() -> void:
	timer.wait_time = dead_time
	timer.one_shot = true
	timer.start()
	_transition()

func _on_timer_timeout() -> void:
	animation_player.play("ripple_out")
	_end_transition()
