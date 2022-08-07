extends RigidBody

onready var planet1 = get_node("/root/Weltraum/StaticBody")
onready var planet2 = get_node("/root/Weltraum/StaticBody2")
var gravity_direction = Vector3();
var move_force = 15
var jump_force = 10
var current_planet = null

func _ready():
	current_planet = planet1
	_calc_gravity_direction(current_planet)

func _process(delta):
	_calc_gravity_direction(current_planet)
	_calc_nearest_planet(planet1, planet2)
	_move()

func _calc_nearest_planet(planet1, planet2):
	#Sind die Begrenzungspunkte der Strecke P1(x1, y1, z1) und P2(x2,y2,z2), dann gilt für die Länge s der Strecke:
	#s2 = (x2-x1)2+(y2-y1)2+(z2-z1)2
	var planet1_to_player_distance = abs(((planet1.transform.origin.x - transform.origin.x) * 2) + ((planet1.transform.origin.y - transform.origin.y) * 2) + ((planet1.transform.origin.z - transform.origin.z) * 2) * 1.0000)
	var planet2_to_player_distance = abs(((planet2.transform.origin.x - transform.origin.x) * 2) + ((planet2.transform.origin.y - transform.origin.y) * 2) + ((planet2.transform.origin.z - transform.origin.z) * 2) * 1.0000)
	
	if planet1_to_player_distance >= planet2_to_player_distance:
		current_planet = planet2
	else:
		current_planet = planet1
	
func _integrate_forces(state):
	_walk_around_planet(state)
	

func _calc_gravity_direction(planet_node):
	gravity_direction = (planet_node.transform.origin - transform.origin).normalized()

func _walk_around_planet(state):
	# allign the players y-axis (up and down) with the planet's gravity direciton:
	state.transform.basis.y = -gravity_direction
	

func _move():
	#handles all input and logic related to character movement
	#move
	if Input.is_action_pressed("ui_up"):
		add_central_force(move_force * global_transform.basis.z)
		
	if Input.is_action_pressed("ui_down"):
		add_central_force(move_force * -global_transform.basis.z)

	if Input.is_action_pressed("ui_left"):
		add_central_force(move_force * global_transform.basis.x)

	if Input.is_action_pressed("ui_right"):
		add_central_force(move_force * -global_transform.basis.x)
	
	#jump:
	if Input.is_action_just_pressed("ui_space"):
		apply_impulse(Vector3.UP, jump_force * global_transform.basis.y)
	
#export var rotation_speed := 8.0
###lalal
##var _move_direction := Vector3.ZERO
##var _last_strong_direction := Vector3.FORWARD
##var local_gravity := Vector3.DOWN
##var _should_reset := false
#
###onready var _camera_controller = get_node(camera_path)
###onready var _model: Spatial = $AstronautSkin
###onready var _start_position := global_transform.origin
##func _ready():
##	pass
##func _integrate_forces(state: PhysicsDirectBodyState) -> void:
##	# This clause handles if a player falls off a planet, resetting
##	# their position if they hit the saftey net.
##	if _should_reset:
##		state.transform.origin = _start_position
##		_should_reset = false
##
##	local_gravity = state.total_gravity.normalized()
##
##	# To not orient quickly to the last input, we save a last strong direction
##	# this also ensures a good normalized value for the rotation basis.
##	if _move_direction.length() > 0.2:
##		_last_strong_direction = _move_direction.normalized()
##
##	_move_direction = _get_model_oriented_input()
##	_orient_character_to_direction(_last_strong_direction, state.step)
##
###	if is_jumping(state):
###		_model.jump()
###		apply_central_impulse(-loacal_gravity * jump_initial_impulse)
###	if is_on_floor(state) and not _model.is_falling():
###		add_central_force(_move_direction * move_speed)
###	_model.velocity = state.linear_velocity
##
##func _get_model_oriented_input() -> Vector3:
##	var input_left_right := (
##		Input.get_action_strength("move_left")
##		- Input.get_action_strength("move_right")
##	)
##	var input_forward := Input.get_action_strength("move_up")
##
##	var raw_input = Vector2(input_left_right, input_forward)
##
##	var input := Vector3.ZERO
##	# This ensures correct analouge input strength in any direction
##	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
##	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)
##
##	input = _model.transform.basis.xform(input)
##	return input
##
##func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
##	var left_axis := -local.gravity.cross(direction)
##	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
##	_model.transform.basis = _model.tranform.basis.get_rotation_quat().slerp(
##		rotation_basis, delta * rotation_speed
##	)
##
