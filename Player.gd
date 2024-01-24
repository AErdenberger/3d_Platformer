extends CharacterBody3D

@export var view: Node3D

var move_speed = 250
var move_velocity: Vector3

var score : int

var gravity:float = 0
var jump_strength = 7

var rotation_direction : float

var previously_floored = false

var jump_single = true
var jump_double = true

@onready var model = $Model
@onready var score_text : Label = get_node("ScoreText")

func _physics_process(delta):
	handle_controls(delta)
	handle_gravity(delta)
	
	#Movement
	var applied_velocity : Vector3
	#velocity is from CharacterBody
	#Lerp - Returns the result of the linear interpolation between this vector and to by amount weight. 
		#weight is on the range of 0.0 to 1.0, representing the amount of interpolation.
	applied_velocity = velocity.lerp(move_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()
	
	if position.y < -10:
		get_tree().reload_current_scene()
		
	model.scale = model.scale.lerp(Vector3(1,1,1), delta * 10)
	
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		
	previously_floored = is_on_floor()
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
		
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

	pass
	
func handle_controls(delta):
	var input := Vector3.ZERO
	
	#Get axis input by specifying two actions, one negative and one positive.
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	
	move_velocity = input * move_speed * delta
	
	if Input.is_action_just_pressed("jump"):
		if(jump_double):
			gravity = -jump_strength
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
		if(jump_single): 
			jump()
		
	pass
	
func jump():
	
	gravity = -jump_strength
	
	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false
	jump_double = true
	
func handle_gravity(delta):
	gravity += 25 * delta
	if gravity > 0 and is_on_floor():
		gravity = 0
		jump_single = true
		
func game_over():
	get_tree().reload_current_scene()
	
func add_score(amount):
	score += amount
	score_text.text = str("Score: ", score) #str() will concatinate the the label text with the score amount
