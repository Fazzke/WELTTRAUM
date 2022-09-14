extends KinematicBody

export var falling_speed = 0.4
export var jumping_speed = 0.2
export var movement_speed = 0.2 # accellerate
export var rotating_speed = 0.2
export var gravity = -10
export var energy_loss = 1 # abriebskraft / friction

# @see https://godotengine.org/qa/38153/how-use-kinematicbodys-move_and_slide-move-object-forward
#var global_direction = Vector3(0,-1,0)
#var local_direction = global_direction.rotated(Vector3(0,1,0), rotation.y)
#var movementVelocity = local_direction * movement_speed
#var fallingVelocity = local_direction * falling_speed
# @see https://godotengine.org/qa/17229/how-does-the-kinematic-body-is_on_floor-function-work
var upwards = Vector3(0,1,0)
var global_direction = Vector3()
var local_direction = Vector3()
var velocity = Vector3()
var desired_velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	#print(upwards)
	
	var planet = get_node("/root/Weltraum/StaticBody")
	
	upwards = (planet.transform.origin - transform.origin).normalized()
	
	velocity.y -= gravity * delta
	desired_velocity = Vector3(0, 0, 0)
	
	if is_on_floor():
		energy_loss = 10
	else:
		energy_loss = 1
	pass
	
	energy_loss *= delta
	
	if Input.is_action_pressed("ui_up"):
		desired_velocity += transform.basis.y  * movement_speed * delta
	if Input.is_action_pressed("ui_down"):
		desired_velocity += transform.basis.y * movement_speed * delta
	if Input.is_action_pressed("ui_left"):
		desired_velocity += transform.basis.z * movement_speed * rotating_speed * delta
	if Input.is_action_pressed("ui_right"):
		desired_velocity += transform.basis.z * movement_speed * -rotating_speed * delta
	if Input.is_action_just_pressed("ui_space") and is_on_floor():
		velocity.y += 4 * movement_speed
		desired_velocity.y += 4 * falling_speed
		
	velocity = move_and_slide(lerp(velocity, desired_velocity, energy_loss), upwards)
