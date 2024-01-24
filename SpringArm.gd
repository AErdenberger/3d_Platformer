extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120

@onready var camera = $Camera3D

var camera_rotation:Vector3
var zoom = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	
	camera_rotation = rotation_degrees
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)
	pass
	
func handle_input(delta):
	#Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	#Limit the camera rotation
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	#we don't want the camera to go directly below or directly above the character
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
