extends Control
class_name Desktop

@onready var window_layer: Control = %WindowLayer
@onready var taskbar: FlowContainer = %TaskbarGrid

var previous_count = 0


func _ready() -> void:
	Global.window_layer = window_layer
	Global.desktop = self


func _process(delta: float) -> void:
	print(Global.current_windows.size() == previous_count)
	if Global.current_windows.size() != previous_count:
		
		for window in taskbar.get_children():
			window.queue_free()
		
		for window in Global.current_windows:
			if window.show_on_taskbar:
				var button_scene: Node = load("res://scenes/instantiated_scenes/ui/taskbar_button.tscn").instantiate()
				button_scene.attached_node = window
				button_scene.program_name = window.window_name
				button_scene.button_icon = window.window_icon
				taskbar.add_child(button_scene)
				
		previous_count = Global.current_windows.size()
	
func update_focus():
	for button in taskbar.get_children():
		
		if button.attached_node.focused:
			
			button.button_pressed = true
		else:
			
			button.button_pressed = false
