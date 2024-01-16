extends CharacterBody3D

var move_speed : float = 4.0
var jump_force : float = 10.0
var gravity : float = 20.0

var facing_angle : float

var score : int

#var _velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN

@onready var model : MeshInstance3D = get_node("Model")
@onready var _spring_arm : SpringArm3D = $SpringArm
@onready var score_text : Label = get_node("ScoreText")

@export var sensitivity : int = 500
@export var camera_path : NodePath
@onready var camera = get_node(camera_path)

func _physics_process(delta):
	
	#apply gravity if we're in the air
	if not is_on_floor():
		velocity.y -= gravity * delta

	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	#get keyboard input
	#var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#calculate move direction
	#var dir = Vector3(input.x, 0, input.y)
	
	#assign direction to velocity
	velocity.x = move_direction.x * move_speed 
	velocity.z = move_direction.z * move_speed
	velocity.y -= gravity * delta
	
	var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN #snap the character to the floor
	 
	#apply velocity
	move_and_slide()
	
	#if we're moving, set facing direction
	if velocity.length() > 0:
		facing_angle = Vector2(velocity.y, velocity.x).angle()
		model.rotation.y = lerp_angle(model.rotation.y, facing_angle, 0.5)
		
	if global_position.y < -5:
		game_over()
		
func _process(delta):
	_spring_arm.position.y = position.y + 0.05
	_spring_arm.position.z = position.z + 0.005

func game_over():
	get_tree().reload_current_scene()
	
	
func add_score(amount):
	score += amount
	score_text.text = str("Score: ", score) #str() will concatinate the the label text with the score amount
	
	
#func _input(event):
	#if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	#	rotation.y -= event.relative.x / sensitivity
		
	#	$CameraPivot.rotation.x -= event.relative.y / sensitivity
	#	$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-45), deg_to_rad(45))
