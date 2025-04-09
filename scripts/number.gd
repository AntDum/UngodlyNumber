extends CharacterBody2D
class_name Number

@export var speed = 100
@export var speed_following = 1000
@export var min_change_direction_time = 1.5
@export var max_change_direction_time = 3.0
@export var min_idle_time = 0.5
@export var max_idle_time = 2.0

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var value: Label = $Value
var label_settings : LabelSettings

enum State {
	IDLE,
	MOVING,
	GRABBED,
	KILLED
}

var current_state : State = State.IDLE

var change_direction_time = 1.0
var idle_time = 0.5

var direction = Vector2.ZERO
var time_since_change = 0.0

var tween : Tween

var number : GodlyNumber

func _on_tree_entered() -> void:
	EventBus.retry.connect(_on_retry)

func _on_tree_exiting() -> void:
	EventBus.retry.disconnect(_on_retry)


func _ready() -> void:
	label_settings = LabelSettings.new()
	label_settings.font_size = 50
	label_settings.set_outline_color(Color.FIREBRICK)
	label_settings.outline_size = 1
	value.set_label_settings(label_settings)
	
	_change_direction()

func _physics_process(delta: float) -> void:
	time_since_change += delta

	match current_state:
		State.IDLE, State.MOVING:
			if ray_cast_2d.is_colliding() or time_since_change >= change_direction_time:
				_change_direction()
				time_since_change = 0.0
			velocity = direction * speed * delta * 60
		State.GRABBED:
			_follow_mouse()
			if global_position.distance_to(get_global_mouse_position()) > 20:
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
	match current_state:
		State.MOVING:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			ray_cast_2d.target_position = direction * speed / 2
			current_state = State.IDLE
		State.IDLE:
			direction = Vector2.ZERO
			current_state = State.MOVING

func _follow_mouse() -> void:
	direction = global_position.direction_to(get_global_mouse_position())

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_killed(): return
	if event is InputEventMouseButton:
		if event.pressed and not event.double_click:
			if event.button_index == MOUSE_BUTTON_LEFT:
				_get_selected()
				_squish_effect()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				EventBus.kill.emit(self)
		elif event.double_click:
			EventBus.split.emit(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			_get_unselected()

func is_killed() -> bool:
	return current_state == State.KILLED

func kill() -> void:
	current_state = State.KILLED
	if tween:
		tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale:y", 0, 0.15)
	tween.tween_callback(queue_free)

func _get_selected():
	current_state = State.GRABBED
	label_settings.outline_size = 15
	label_settings.outline_color = Color.FIREBRICK
	animation_player.speed_scale = 2

func _get_unselected():
	current_state = State.IDLE
	label_settings.outline_size = 1
	label_settings.outline_color = Color.BLACK
	animation_player.speed_scale = 1

func illuminate() -> void:
	animation_player.speed_scale = 2
	var label_setting := value.get_label_settings()
	label_setting.outline_size = 1
	label_setting.outline_color = Color.WHITE
	label_setting.font_color = Color.FIREBRICK

func _on_retry() -> void:
	kill()

func set_number(new_number: GodlyNumber) -> void:
	number = new_number
	$Value.text = str(self.number.value)

func _on_area_2d_mouse_entered() -> void:
	_squish_effect()

func _squish_effect() -> void:
	if tween:
		tween.kill()
	# Crée le tween avec une interpolation élastique pour un effet rebondissant
	tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	# Squash : on étire l'axe X et on compresse l'axe Y
	tween.tween_property(self, "scale:x", 1.1, 0.05)
	tween.tween_property(self, "scale:y", 0.9, 0.05)
	# Retour à l'échelle normale (1,1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05)


func _on_value_resized() -> void:
	$CollisionShape2D.shape.height = value.size.x + 10
