extends CharacterBody2D



func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	if Input.is_action_pressed("pressed_up"):
		velocity.y = 100.0
		
	move_and_slide()
