extends TextureButton

@export_enum("Box", "Lead", "Sky") var ad_type: int
@export var has_malware = false

var ad_number = randi_range(0,0)

var box_path = "res://asset/ui/web/ad/box_"
var sky_path = "res://asset/ui/web/ad/sky_"
var lead_path = "res://asset/ui/web/ad/lead_"

func _ready() -> void:
	
	match ad_type:
		
		0:
		
			texture_normal = load(box_path + str(ad_number) + ".png")
			custom_minimum_size = Vector2(128.0, 128.0)
		1:
		
			texture_normal = load(lead_path + str(ad_number) + ".png")
			custom_minimum_size = Vector2(500.0, 64.0)
		
		2:
		
			texture_normal = load(sky_path + str(ad_number) + ".png")
			custom_minimum_size = Vector2(128.0, 480.0)

func _on_close_btn_button_up() -> void:
	queue_free()
