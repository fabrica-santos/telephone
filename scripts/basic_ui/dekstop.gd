extends Control
class_name Desktop

@onready var window_layer: Control = %WindowLayer


func _ready() -> void:
	Global.window_layer = window_layer


func _process(delta: float) -> void:
	pass
