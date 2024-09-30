extends Node


var app_database: Dictionary = {
	"dinossaur": {
		"icon": "dino.png",
		"name": "Dinossaur Game",
		"scene_file": "res://scenes/apps/games/dinossaur.tscn",
		"wind_size": Vector2(300,250),
		"wind_min": Vector2(100,100),
		"wind_max": Vector2(400,400),
		"drag": true,
		"resize_w": true,
		"resize_h": true,
		"can_min": true,
		"can_wind": true,
		"can_close": true,
		"task_bar": true,
		"destroy": true,
		"main_focus": false,
	}
}
var big_icon_dir: String = "res://assets/basic_ui/placeholder/big_icon/"
var mid_icon_dir: String = ""
var small_icon_dir: String = "res://assets/basic_ui/placeholder/small_icon/"

var window_scene = load("res://scenes/instantiated_scenes/window_object.tscn")

#NODES
var window_layer: Node = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_application(app_name: String = ""):
	create_window(Global.app_database[app_name]["scene_file"], Global.app_database[app_name]["icon"], Global.app_database[app_name]["name"], Vector2(250.0, 250.0), Global.app_database[app_name]["drag"], Global.app_database[app_name]["resize_w"], Global.app_database[app_name]["resize_h"], Global.app_database[app_name]["main_focus"], Global.app_database[app_name]["can_min"], Global.app_database[app_name]["can_wind"], Global.app_database[app_name]["can_close"], Global.app_database[app_name]["task_bar"], Global.app_database[app_name]["wind_size"], Global.app_database[app_name]["wind_min"], Global.app_database[app_name]["wind_max"], Global.app_database[app_name]["destroy"])


func create_window(window_content: String, icon: String = "", title: String = "", position: Vector2 = Vector2(250.0, 250.0), drag: bool = true, resize_w: bool = true, resize_h: bool = true, main_focus: bool = false, can_min: bool = true, can_wind: bool = true, can_close: bool = true, task_bar: bool = true, size: Vector2 = Vector2(100.0, 100.0), min_size: Vector2 = Vector2(100.0, 100.0), max_size: Vector2 = Vector2(800.0, 600.0), destroy: bool = true):
	var window_instance = window_scene.instantiate()
	window_instance.window_icon = load(Global.small_icon_dir+icon)
	window_instance.window_name = title
	window_instance.global_position = position
	window_instance.window_content = load(window_content)
	window_instance.draggable = drag
	window_instance.resizable_width = resize_w
	window_instance.resizable_height = resize_h
	window_instance.main_focus = main_focus
	window_instance.can_minimize = can_min
	window_instance.can_window = can_wind
	window_instance.can_close = can_close
	window_instance.show_on_taskbar = task_bar
	window_instance.start_size = size
	window_instance.min_size = min_size
	window_instance.max_size = max_size
	window_instance.destroy_if_closed = destroy
	window_layer.add_child(window_instance)
