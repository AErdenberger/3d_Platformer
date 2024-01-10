extends SpringArm3D

@export var mouse_sensitivity : float = 0.05


# Called when the node enters the scene tree for the first time.
func _ready():
	#camera can move independently of the character
	#won't inherit its position, rotation or scale
	top_level = true 
	
	#hides and locks the cursor to the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		#clamp prevents the camera from rolling over, limiting the cameras movement
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		#the wrapf function will keep the rotation from going over 360 degrees
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
