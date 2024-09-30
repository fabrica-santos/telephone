extends Control

const RESIZE_BORDER_SIZE = 5

@export_category("General Properties")
@export var window_content: PackedScene
@export var draggable: bool = true
@export var can_window: bool = true
@export var can_minimize: bool = true
@export var can_close: bool = true
@export var is_maximized: bool = false
@export var main_focus: bool = false
@export var destroy_if_closed: = true
@export var show_on_taskbar: = false
@export_category("Header Properties")
@export var window_name: String = ""
@export var window_icon: CompressedTexture2D
@export_category("Size Properties")
@export var resizable_width: bool = true
@export var resizable_height: bool = true
@export var start_size: Vector2 = Vector2(100.0, 100.0)
@export var min_size: Vector2 = Vector2(100.0, 100.0)
@export var max_size: Vector2 = Vector2(600.0, 800.0)

var _closed: bool = false
var _initial_mouse: Vector2
var _initial_pos: Vector2
var _initial_size: Vector2
var _mouse_on_header: bool = false
var _focused: bool = false
var _is_moving: bool = false
var _resizing: Vector2 = Vector2(false, false)
var _is_resizing: bool = false
var _original_window_size: Vector2
var _original_window_pos: Vector2

@onready var window_canvas: Control = %WindowCanvas
@onready var min_btn: TextureButton = %MinBtn
@onready var wind_btn: TextureButton = %WindBtn
@onready var close_btn: TextureButton = %CloseBtn
@onready var window_label: Label = %WindowName
@onready var icon_texture: TextureRect = %WindowIcon


func _ready():
	min_btn.visible = can_minimize
	min_btn.disabled = !can_minimize
	wind_btn.visible = can_window
	wind_btn.disabled = !can_window
	close_btn.visible = can_close
	close_btn.disabled = !can_close
	window_label.text = window_name
	
	if window_icon != null:
		icon_texture.texture = window_icon
	
	else:
		%IconContainer.visible = false
	
		
	if window_content != null:
		var content_instance: Node = window_content.instantiate()
		window_canvas.add_child(content_instance)
		
	set_size(start_size)


func _gui_input(event) -> void:
	var _window_rect: Rect2 = get_global_rect()
	var _local_mouse_pos: Vector2 = get_global_mouse_position() - get_global_position()

	if Input.is_action_just_pressed("left_click"):
		
		if _mouse_on_header:
			
			if draggable && _focused:
				_initial_mouse = get_global_mouse_position()
				_initial_pos = get_global_position()
				
				if is_maximized:
					set_size(Vector2(clamp(get_size().x / 2.0, min_size.x, max_size.x), clamp(get_size().y / 2.0, min_size.y, max_size.y)))
					set_position(_initial_pos + (event.position - _initial_mouse))
					set_global_position(Vector2(event.position.x - get_size().x / 2.0, get_position().y))
					_initial_mouse = get_global_mouse_position()
					_initial_pos = get_global_position()
					is_maximized = false
				
				_is_moving = true
		
		else:
			
			if resizable_width:
				
				if abs(_local_mouse_pos.x - _window_rect.size.x) < RESIZE_BORDER_SIZE:
					_initial_mouse.x = event.position.x
					_initial_size.x = get_size().x
					_is_resizing = true
					_resizing.x = true
					
				if _local_mouse_pos.x < RESIZE_BORDER_SIZE && _local_mouse_pos.x > -RESIZE_BORDER_SIZE:
					_initial_mouse.x = event.position.x
					_initial_size.x = get_size().x
					_initial_pos.x = get_global_position().x
					_is_resizing = true
					_resizing.x = true
			
			if resizable_height:
				
				if abs(_local_mouse_pos.y - _window_rect.size.y) < RESIZE_BORDER_SIZE:
					_initial_mouse.y = event.position.y
					_initial_size.y = get_size().y
					_is_resizing = true
					_resizing.y = true
		
	if Input.is_action_pressed("left_click") && _focused:
		
		if _is_moving:
			set_position(_initial_pos + (get_global_mouse_position() - _initial_mouse))

		
		if _is_resizing:
			var _new_size: Vector2 = Vector2(get_size().x, get_size().y)
			
			if resizable_width:
				
				if _resizing.x:
					_new_size.x = _initial_size.x - (_initial_mouse.x - event.position.x)
				
				if _initial_pos.x != 0:
					_new_size.x = _initial_size.x + (_initial_mouse.x - event.position.x)
					
					if get_size().x > min_size.x:
						set_position(Vector2(_initial_pos.x - (_new_size.x - _initial_size.x), get_position().y))
						
			if resizable_height:
				
				if _resizing.y:
					_new_size.y = _initial_size.y - (_initial_mouse.y - event.position.y)
			
				if _initial_pos.y != 0:
					_new_size.y = _initial_size.y + (_initial_mouse.y - event.position.y)
			
			set_size(Vector2(clamp(_new_size.x, min_size.x, max_size.x), clamp(_new_size.y, min_size.y, max_size.y)))
				
	if Input.is_action_just_released("left_click"):
		_is_moving = false
		_initial_pos = Vector2.ZERO
		_is_resizing = false
		_resizing = Vector2(false, false)

	if event.is_action("double_click", true) && _mouse_on_header && !is_maximized && can_window && event.is_double_click():
		toggle_maximize()
		


func toggle_maximize():
	
	if !is_maximized:
		_original_window_pos = global_position
		_original_window_size = get_size()
		set_anchors_preset(Control.PRESET_FULL_RECT, true)
		set_offset(SIDE_LEFT, 0.0)
		set_offset(SIDE_RIGHT, 0.0)
		set_offset(SIDE_TOP, 0.0)
		set_offset(SIDE_BOTTOM, 0.0)
		global_position = Vector2.ZERO
		_on_panel_focus_entered()
		is_maximized = true
	
	else:
		set_anchors_preset(Control.PRESET_TOP_LEFT, true)
		set_size(_original_window_size)
		set_position(_original_window_pos)
		is_maximized = false


func _on_header_mouse_entered() -> void:
	_mouse_on_header = true
	#print("WINDOW_HEADER_ENTERED")


func _on_header_mouse_exited() -> void:
	_mouse_on_header = false
	#print("WINDOW_HEADER_EXITED")


func _on_panel_focus_entered() -> void:
	_focused = true
	window_canvas.set_process_input(_focused)
	get_parent().move_child(self, get_parent().get_child_count())
	#print("WINDOW_FOCUSED")


func _on_panel_focus_exited() -> void:
	_focused = false
	_is_moving = false
	_is_resizing = false
	_resizing = Vector2(false, false)
	window_canvas.set_process_input(_focused)
	#print("WINDOW_UNFOCUSED")


func _on_wind_btn_up() -> void:
	toggle_maximize()


func _on_close_btn_button_up() -> void:
	
	if destroy_if_closed:
		queue_free()
	
	else:
		_focused = false
		_is_moving = false
		_is_resizing = false
		window_canvas.set_process_input(_focused)
		visible = false
		_closed = true
