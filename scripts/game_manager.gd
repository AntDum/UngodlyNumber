extends Node

var selected : Number = null

func _ready() -> void:
	EventBus.selected.connect(_on_number_selected)

func _on_number_selected(number : Number) -> void:
	pass
