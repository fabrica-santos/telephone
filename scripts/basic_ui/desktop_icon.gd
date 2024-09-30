extends Control


@export_category("General Properties")
@export var application: String
@export var is_shortcut: bool = false
@export var open_folder: bool = false
@export var has_loading: bool = false
@export var min_load: float
@export var max_load: float

@onready var icon_img: TextureRect = %IconImg
@onready var title_label: Label = %TitleLabel
@onready var focused_color: ColorRect = %FocusedColor

var _initial_mouse: Vector2
var _initial_pos: Vector2
var _initial_size: Vector2
var _is_moving: bool = false
var _first_click: bool = false
var _focused = false


func _ready() -> void:
	
	if Global.app_database[application]["icon"] != "":
		icon_img.texture = load(Global.big_icon_dir + Global.app_database[application]["icon"])

	if title_label.text != null || title_label.text != "":
		title_label.text = Global.app_database[application]["name"]


func _input(event) -> void:
	var _window_rect: Rect2 = get_global_rect()
	var _local_mouse_pos: Vector2 = get_global_mouse_position() - get_global_position()

	if Input.is_action_just_pressed("left_click"):
		if _focused:
			_initial_mouse = event.position
			_initial_pos = get_global_position()
			_is_moving = true
	
	if Input.is_action_pressed("left_click") && _is_moving:
		var new_position: Vector2 = _initial_pos + (get_global_mouse_position() - _initial_mouse)
		set_position(Vector2(clamp(new_position.x, 0.0, 800.0 - get_size().x), clamp(new_position.y, 0.0, 600.0 - get_size().y)))

	if Input.is_action_just_released("left_click"):
		_is_moving = false
		_initial_pos = Vector2.ZERO
	
	if event.is_action("double_click", true):
		if _focused && event.is_double_click():
			Global.open_application(application)
			_on_icon_focus_exited()


func _on_icon_focus_entered() -> void:
	_focused = true
	focused_color.visible = _focused

func _on_icon_focus_exited() -> void:
	_focused = false
	focused_color.visible = _focused
