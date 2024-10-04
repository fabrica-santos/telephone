extends Resource
class_name WindowSettings

@export_category("General Properties")
@export var application_name: String = ""
@export var window_content: PackedScene
@export var draggable: bool = true
@export var can_window: bool = true
@export var can_minimize: bool = true
@export var can_close: bool = true
@export var maximize_at_start: bool = false
@export var main_focus: bool = false
@export var destroy_if_closed: bool = true
@export var show_on_taskbar: bool = true
@export var has_inner_frame: bool = true
@export var is_malware: bool = false
@export_category("Icon Properties")
@export var desktop_icon: CompressedTexture2D
@export var window_icon: CompressedTexture2D
@export_category("Header Properties")
@export var window_name: String = ""
@export_category("Size Properties")
@export var resizable_width: bool = true
@export var resizable_height: bool = true
@export var start_size: Vector2 = Vector2(100.0, 100.0)
@export var min_size: Vector2 = Vector2(100.0, 100.0)
@export var max_size: Vector2 = Vector2(800.0, 600.0)
