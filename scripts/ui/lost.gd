extends CanvasLayer

@export var stat_manager: StatManager

func _ready() -> void:
	EventBus.lost.connect(_on_lost)
	
func _on_lost() -> void:
	_update_layout()
	show_layout()

func _update_layout() -> void:
	%score_label.text = str(stat_manager.score)
	%round_label.text = str(stat_manager.round_played)
	%killed_label.text = str(stat_manager.ungodly_killed)

func show_layout() -> void:
	visible = true
	
func hide_layout() -> void:
	visible = false

func _on_retry_button_pressed() -> void:
	hide_layout()
	EventBus.retry.emit()
