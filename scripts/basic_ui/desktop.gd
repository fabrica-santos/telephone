extends Control
class_name Desktop

@onready var window_layer: Control = %WindowLayer
@onready var taskbar: FlowContainer = %TaskbarGrid

var window_scene = load("res://scenes/instantiated_scenes/ui/window_object.tscn")
var current_windows: Array = []:
	set(value):
		print("OK")


func _ready() -> void:
	EventBus.window_created.connect(update_taskbar)
	EventBus.window_destroyed.connect(update_taskbar)
	EventBus.window_open_requested.connect(create_window)
	EventBus.window_focused.connect(update_focus)


func update_taskbar():
	for window in taskbar.get_children():
		window.queue_free()
	
	for window in window_layer.get_children():
		if window.window_settings.show_on_taskbar:
			var button_scene: Node = load("res://scenes/instantiated_scenes/ui/taskbar_button.tscn").instantiate()
			button_scene.attached_node = window
			button_scene.program_name = window.window_settings.application_name
			button_scene.button_icon = window.window_settings.window_icon
			taskbar.add_child(button_scene)


func update_focus(window: Node):
	for button in taskbar.get_children():
		if button.attached_node == window:
			button.button_pressed = true
		else:
			button.button_pressed = false


func create_window(app: WindowSettings) -> void:
	var _window_instance: Node = window_scene.instantiate()
	_window_instance.window_settings = app
	window_layer.add_child(_window_instance)
