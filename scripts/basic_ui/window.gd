extends Control

const RESIZE_BORDER_SIZE = 4

@export_category("General Properties")
@export var window_content: PackedScene
@export var draggable: bool = true
@export var can_maximize: bool = true
@export var can_minimize: bool = true
@export var is_maximized: bool = false
@export var main_focus: bool = false
@export var destroy_if_closed: = false
@export var show_on_taskbar: = false

@export_category("Size Properties")
@export var resizable_width: bool = true
@export var resizable_height: bool = true
@export var start_size: Vector2 = Vector2(100.0, 100.0)
@export var min_size: Vector2 = Vector2(100.0, 100.0)
@export var max_size: Vector2 = Vector2(600.0, 800.0)

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

func _ready():
	min_btn.visible = can_maximize
	min_btn.disabled = !can_maximize
	wind_btn.visible = can_maximize
	wind_btn.disabled = !can_maximize


func _input(event) -> void:
	var _window_rect: Rect2 = get_global_rect()
	var _local_mouse_pos: Vector2 = event.position - get_global_position()
	
	if resizable_width && abs(_local_mouse_pos.x - _window_rect.size.x) < RESIZE_BORDER_SIZE:
		mouse_default_cursor_shape = Control.CURSOR_HSIZE
			
	if Input.is_action_just_pressed("left_click"):
		
		if _mouse_on_header:
			if draggable && _focused:
				_initial_mouse = event.position
				_initial_pos = get_global_position()
				
				if is_maximized:
					set_size(Vector2(clamp(get_size().x / 2.0, min_size.x, max_size.x), clamp(get_size().y / 2.0, min_size.y, max_size.y)))
					set_position(_initial_pos + (event.position - _initial_mouse))
					set_global_position(Vector2(event.position.x - get_size().x / 2.0, get_position().y))
					#set_position(_initial_pos + (event.position - _initial_mouse))
					_initial_mouse = event.position
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
					
				if _local_mouse_pos.y < RESIZE_BORDER_SIZE && _local_mouse_pos.y > -RESIZE_BORDER_SIZE:
					_initial_mouse.y = event.position.y
					_initial_size.y = get_size().y
					_initial_pos.y = get_global_position().y
					_is_resizing = true
					_resizing.y = true
		
	if Input.is_action_pressed("left_click") && _focused:
		
		if _is_moving:
			set_position(_initial_pos + (event.position - _initial_mouse))
		
		if _is_resizing:
			var _new_size: Vector2 = Vector2(get_size().x, get_size().y)
			
			if resizable_width:
				
				if _resizing.x:
					_new_size.x = _initial_size.x - (_initial_mouse.x - event.position.x)
				
				if _initial_pos.x != 0:
					_new_size.x = _initial_size.x + (_initial_mouse.x - event.position.x)
					set_position(Vector2(_initial_pos.x - (_new_size.x - _initial_size.x), get_position().y))
				
			if resizable_height:
				
				if _resizing.y:
					_new_size.y = _initial_size.y - (_initial_mouse.y - event.position.y)
			
				if _initial_pos.y != 0:
					_new_size.y = _initial_size.y + (_initial_mouse.y - event.position.y)
					set_position(Vector2(get_position().x, _initial_pos.y - (_new_size.y - _initial_size.y)))
			
			set_size(Vector2(clamp(_new_size.x, min_size.x, max_size.x), clamp(_new_size.y, min_size.y, max_size.y)))
				
	if Input.is_action_just_released("left_click"):
		_is_moving = false
		_initial_pos = Vector2.ZERO
		_is_resizing = false
		_resizing = Vector2(false, false)


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
		is_maximized = true
	else:
		set_anchors_preset(Control.PRESET_TOP_LEFT, true)
		set_size(_original_window_size)
		set_position(_original_window_pos)
		is_maximized = false
		


func _on_mouse_entered_header() -> void:
	_mouse_on_header = true


func _on_mouse_exited_header() -> void:
	_mouse_on_header = false


func _on_panel_focus_entered() -> void:
	_focused = true
	window_canvas.set_process_input(_focused)
	z_index = _focused


func _on_panel_focus_exited() -> void:
	_focused = false
	_is_moving = false
	_is_resizing = false
	_resizing = Vector2(false, false)
	window_canvas.set_process_input(_focused)
	z_index = _focused

func _on_wind_btn_up() -> void:
	toggle_maximize()
	
