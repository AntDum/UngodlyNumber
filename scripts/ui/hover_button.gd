extends Button

var tween : Tween

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
func _on_mouse_entered() -> void:
	pivot_offset = size / 2
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE * 1.4, 0.15)

func _on_mouse_exited() -> void:
	pivot_offset = size / 2
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
