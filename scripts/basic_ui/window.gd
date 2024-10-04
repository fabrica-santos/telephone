extends Control
class_name DesktopWindow

const RESIZE_BORDER_SIZE = 5

@export var window_settings = load("res://resources/windows/default.tres")
@export var focused: bool = false
@export var is_maximized: bool = false

var closed: bool = false
var initial_mouse: Vector2
var initial_pos: Vector2
var initial_size: Vector2
var mouse_on_header: bool = false
var is_moving: bool = false
var resizing: Vector2 = Vector2(false, false)
var is_resizing: bool = false
var original_window_size: Vector2
var original_window_pos: Vector2
var minimize_tex_array: Array = ["res://assets/basic_ui/mini_icon/max_btn.png", "res://assets/basic_ui/mini_icon/wind_btn.png"]
var outside_popup: bool = false
var taskbar_booted: bool = false

@onready var win_panel: Panel = %Panel
@onready var window_canvas: Control = %WindowCanvas
@onready var min_btn: Button = %MinBtn
@onready var wind_btn: Button = %WindBtn
@onready var close_btn: Button = %CloseBtn
@onready var window_label: Label = %WindowName
@onready var icon_texture: TextureRect = %WindowIcon
@onready var inner_frame: Panel = %InnerFrame
@onready var header_bg: ColorRect = %HeaderBG
@onready var prevent_click: Container = %PreventClick


func _ready():
	EventBus.window_created.emit()
	
	win_panel.grab_focus()
	grab_click_focus()
	min_btn.visible = window_settings.can_minimize
	min_btn.disabled = !window_settings.can_minimize
	wind_btn.visible = window_settings.can_window
	wind_btn.disabled = !window_settings.can_window
	close_btn.visible = window_settings.can_close
	close_btn.disabled = !window_settings.can_close
	window_label.text = window_settings.window_name
	
	if window_settings.main_focus:
		grab_focus()
	else:
		prevent_click.queue_free()
	
	if window_settings.window_icon != null:
		icon_texture.texture = window_settings.window_icon
	
	else:
		%IconContainer.visible = false
	
		
	if window_settings.window_content != null:
		var content_instance: Node = window_settings.window_content.instantiate()
		window_canvas.add_child(content_instance)
	
	if !window_settings.has_inner_frame:
		inner_frame.visible = false
		inner_frame.get_parent().get_child(1).remove_theme_constant_override("margin")
	
	if window_settings.maximize_at_start:
		toggle_maximize()
	
	set_size(window_settings.start_size)


func _gui_input(event) -> void:
	var _window_rect: Rect2 = get_global_rect()
	var _local_mouse_pos: Vector2 = get_global_mouse_position() - get_global_position()
	
	if Input.is_action_just_pressed("left_click"):
			
		if mouse_on_header:
			
			if window_settings.draggable && focused:
				initial_mouse = get_global_mouse_position()
				initial_pos = get_global_position()
				
				if is_maximized:
					set_size(Vector2(clamp(get_size().x / 2.0, window_settings.min_size.x, window_settings.max_size.x), clamp(get_size().y / 2.0, window_settings.min_size.y, window_settings.max_size.y)))
					set_position(initial_pos + (event.position - initial_mouse))
					set_global_position(Vector2(event.position.x - get_size().x / 2.0, get_position().y))
					initial_mouse = get_global_mouse_position()
					initial_pos = get_global_position()
					is_maximized = false
					wind_btn.get_child(0).texture = load(minimize_tex_array[int(is_maximized)])
				
				is_moving = true
		
		else:
			
			if window_settings.resizable_width:
				
				if abs(_local_mouse_pos.x - _window_rect.size.x) < RESIZE_BORDER_SIZE:
					initial_mouse.x = event.position.x
					initial_size.x = get_size().x
					is_resizing = true
					resizing.x = true
					
				if _local_mouse_pos.x < RESIZE_BORDER_SIZE && _local_mouse_pos.x > -RESIZE_BORDER_SIZE:
					initial_mouse.x = event.position.x
					initial_size.x = get_size().x
					initial_pos.x = get_global_position().x
					is_resizing = true
					resizing.x = true
			
			if window_settings.resizable_height:
				
				if abs(_local_mouse_pos.y - _window_rect.size.y) < RESIZE_BORDER_SIZE:
					initial_mouse.y = event.position.y
					initial_size.y = get_size().y
					is_resizing = true
					resizing.y = true
					
				if _local_mouse_pos.y < RESIZE_BORDER_SIZE && _local_mouse_pos.y > -RESIZE_BORDER_SIZE:
					initial_mouse.y = event.position.y
					initial_size.y = get_size().y
					initial_pos.y = get_global_position().y
					is_resizing = true
					resizing.y = true
		
	if Input.is_action_pressed("left_click"):
		
		if is_moving && focused:
			var new_position: Vector2 = initial_pos + (get_global_mouse_position() - initial_mouse)
			set_position(Vector2(clamp(new_position.x, 0.0, 800.0 - get_size().x), clamp(new_position.y, 0.0, 600.0 - get_size().y)))
		
		if is_resizing:
			win_panel.grab_focus()
			var _new_size: Vector2 = Vector2(get_size().x, get_size().y)
			
			if window_settings.resizable_width:
				
				if resizing.x:
					_new_size.x = initial_size.x - (initial_mouse.x - event.position.x)
				
				if initial_pos.x != 0:
					_new_size.x = initial_size.x + (initial_mouse.x - event.position.x)
					
					if get_size().x > window_settings.min_size.x:
						set_position(Vector2(initial_pos.x - (_new_size.x - initial_size.x), get_position().y))
						
			if window_settings.resizable_height:
				
				if resizing.y:
					_new_size.y = initial_size.y - (initial_mouse.y - event.position.y)
			
				if initial_pos.y != 0:
					_new_size.y = initial_size.y + (initial_mouse.y - event.position.y)
					set_position(Vector2(get_position().x, initial_pos.y - (_new_size.y - initial_size.y)))
			
			set_size(Vector2(clamp(_new_size.x, window_settings.min_size.x, window_settings.max_size.x), clamp(_new_size.y, window_settings.min_size.y, window_settings.max_size.y)))
			self.grab_click_focus()
	
	if Input.is_action_just_released("left_click"):
		is_moving = false
		initial_pos = Vector2.ZERO
		is_resizing = false
		resizing = Vector2(false, false)
		
		if get_global_position().y == 0.0 && mouse_on_header:
			toggle_maximize()

	#if event.is_action("double_click", true) && _mouse_on_header && !is_maximized && can_window && event.is_double_click():
		#toggle_maximize()
		


func toggle_maximize():
	
	if !is_maximized:
		original_window_pos = global_position
		original_window_size = get_size()
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
		set_size(original_window_size)
		set_position(original_window_pos)
		is_maximized = false
	wind_btn.get_child(0).texture = load(minimize_tex_array[int(is_maximized)])

func focus() -> void:
	win_panel.grab_focus()

func _on_header_mouse_entered() -> void:
	mouse_on_header = true
	#print("WINDOW_HEADER_ENTERED")


func _on_header_mouse_exited() -> void:
	mouse_on_header = false
	#print("WINDOW_HEADER_EXITED")


func _on_panel_focus_entered() -> void:
	EventBus.window_focused.emit(self)
	focused = true
	window_canvas.set_process_input(focused)
	get_parent().move_child.call_deferred(self, get_parent().get_child_count())
	header_bg.color = Color(0.0, 0.0, 0.5)
	#print("WINDOWfocused")


func _on_panel_focus_exited() -> void:
	focused = false
	is_moving = false
	is_resizing = false
	resizing = Vector2(false, false)
	window_canvas.set_process_input(focused)
	
	if window_settings.main_focus:
		var _header_blink_tween: Tween = create_tween().set_loops(3)
		_header_blink_tween.tween_property(header_bg, "color", Color(0.5,0.5,0.5), 0.0).set_trans(Tween.TRANS_QUAD)
		_header_blink_tween.tween_interval(0.1)
		_header_blink_tween.tween_property(header_bg, "color", Color(0.0,0.0,0.5), 0.0).set_trans(Tween.TRANS_QUAD)
		_header_blink_tween.tween_interval(0.1)
		await _header_blink_tween.finished
		win_panel.grab_focus()
	else:
		header_bg.color = Color(0.5, 0.5, 0.5)
	#print("WINDOW_UNFOCUSED")


func _on_wind_btn_up() -> void:
	toggle_maximize()


func _on_close_btn_button_up() -> void:
	
	if window_settings.destroy_if_closed:
		queue_free()
	
	else:
		focused = false
		is_moving = false
		is_resizing = false
		window_canvas.set_process_input(focused)
		visible = false
		closed = true


func _on_tree_exited() -> void:
	EventBus.window_destroyed.emit()
