extends Area3D

var spin_speed : float = 4.0 #amount of revolutions
var bob_height : float = 0.2 #how high the coin is going to bob up and down
var bob_speed : float = 5.0 #how fast the coin bobs up and down

@onready var start_y : float = global_position.y
var t : float = 0.0 #timer for the sin-wave which will keep track of time that has elapsed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3.UP, spin_speed * delta)
	
	t += delta
	var d = (sin(t * bob_speed) + 1) / 2 #change the sin-wave range from 1 -> -1 to 1 -> 0
	global_position.y = start_y + (d * bob_height)
