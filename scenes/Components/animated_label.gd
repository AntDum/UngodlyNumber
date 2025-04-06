extends Label
class_name AnimatedLabel

@export var value : int = 0
var _shown_value : int = 0 : set = _update_shown_value

@export_category("Animation")
@export var transition : Tween.TransitionType = Tween.TRANS_CUBIC
@export var easing : Tween.EaseType = Tween.EASE_OUT
@export var duration : float = 1

var tween : Tween

func set_value(new_value: int) -> void:
	value = new_value
	
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self).set_trans(transition).set_ease(easing)
	tween.tween_property(self, "_shown_value", value, duration)

func _ready() -> void:
	_shown_value = value

func _update_shown_value(new_value:int) -> void:
	_shown_value = new_value
	text = str(_shown_value)
