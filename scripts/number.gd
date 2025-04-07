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
@onready var value: Label = $Value

var change_direction_time = 1.0
var idle_time = 0.5
var is_idle := false
var is_selected = false

var direction = Vector2.ZERO
var time_since_change = 0.0

var tween : Tween

var number : GodlyNumber

func _ready() -> void:
	EventBus.selected.connect(_on_selection)
	var label_settings = LabelSettings.new()
	label_settings.font_size = 50
	label_settings.set_outline_color(Color.FIREBRICK)
	label_settings.outline_size = 1
	value.set_label_settings(label_settings)
		
	_change_direction()

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
	change_direction_time = randf_range(min_change_direction_time, max_change_direction_time)
	idle_time = randf_range(min_idle_time, max_idle_time)
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
	value.get_label_settings().outline_size = 15
	value.get_label_settings().set_outline_color(Color.FIREBRICK)
	animation_player.speed_scale = 2

func _get_unselected():
	is_selected = false
	value.get_label_settings().outline_size = 1
	value.get_label_settings().set_outline_color(Color.BLACK)
	animation_player.speed_scale = 1

func set_number(number: GodlyNumber) -> void:
	self.number = number
	$Value.text = str(self.number.value)


func _on_area_2d_mouse_entered() -> void:
	if tween:
		tween.kill()
	# Crée le tween avec une interpolation élastique pour un effet rebondissant
	tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	# Squash : on étire l'axe X et on compresse l'axe Y
	tween.tween_property(self, "scale:x", 1.1, 0.05)
	tween.tween_property(self, "scale:y", 0.9, 0.05)
	# Retour à l'échelle normale (1,1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05)

func _on_area_2d_mouse_exited() -> void:
	pass # Replace with function body.
