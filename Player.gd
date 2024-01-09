extends CharacterBody3D

var move_speed : float = 4.0
var jump_force : float = 8.0
var gravity : float = 20.0

var facing_angle : float

var score : int

@onready var model : MeshInstance3D = get_node("Model")
@onready var score_text : Label = get_node("ScoreText")

@export var sensitivity : int = 500
@export var camera_path : NodePath
@onready var camera = get_node(camera_path)

func _physics_process(delta):
	
	#apply gravity if we're in the air
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	#get keyboard input
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#calculate move direction
	var dir = Vector3(input.x, 0, input.y)
	
	#assign direction to velocity
	velocity.x = dir.x * move_speed #created and used within CharacterBody3D which we are extending from
	velocity.z = dir.z * move_speed
	
	#apply velocity
	move_and_slide()
	
	#if we're moving, set facing direction
	if input.length() > 0:
		facing_angle = Vector2(input.y, input.x).angle()
		#swap y and x to get y-axis angle
	
	model.rotation.y = lerp_angle(model.rotation.y, facing_angle, 0.5) 
	
	if global_position.y < -5:
		game_over()

func game_over():
	get_tree().reload_current_scene()
	
func add_score(amount):
	score += amount
	score_text.text = str("Score: ", score) #str() will concatinate the the label text with the score amount
	
	
func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		rotation.y -= event.relative.x / sensitivity
		
		$CameraPivot.rotation.x -= event.relative.y / sensitivity
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-45), deg_to_rad(45))
