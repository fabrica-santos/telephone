extends Button

const MAX_SIZE: int = 15

@export var attached_node: Node = null
@export var program_name: String = ""
@export var button_icon: CompressedTexture2D

@onready var icon_texture: TextureRect = $Icon

func _ready() -> void:
	
	while program_name.length() < MAX_SIZE:
		program_name += " "
	
	if program_name.length() > MAX_SIZE:
		program_name = program_name.substr(0, MAX_SIZE - 5) + "..."
	
	text = program_name
	
	if icon_texture != null:
		icon_texture.texture = button_icon
		icon = icon_texture.texture
	
	reset_size()


func _on_button_up() -> void:
	attached_node.focus()
	#
	#for button in get_parent().get_children():
		#if button != self:
			#button.button_pressed = false
