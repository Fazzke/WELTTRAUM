extends RigidBody

onready var centralStar = get_node("/root/Weltraum/Central/CentralBody")
onready var planet1 = get_node("/root/Weltraum/StaticBody")
onready var planet2 = get_node("/root/Weltraum/StaticBody2")
onready var planet3 = get_node("/root/Weltraum/StaticBody3")
var planets = []
var gravity_direction = Vector3();
var move_force = 950
var jump_force = 40
var current_planet = null
var can_jump = false

var game_control = preload("res://scenes/GameOverScreen.tscn")
var game_control_instance = null

func _ready():
	planets = [planet1, planet2, planet3]
	current_planet = centralStar
	_calc_gravity_direction(current_planet)
	
	game_control_instance = game_control.instance()

func _process(delta):
	_calc_gravity_direction(current_planet)
	prevent_player_from_falling()
	_move()

func _physics_process(delta):
	_calc_gravity_direction(current_planet)

func _integrate_forces(state):
	_walk_around_planet(state)
	
func _calc_gravity_direction(planet_node):
	gravity_direction = (planet_node.transform.origin - transform.origin).normalized()

func _check_if_can_jump():
	can_jump = false
	
	for planet in planets:
		if planet.on_planet_ground:
			can_jump = true
			break

func _walk_around_planet(state):
	# allign the players y-axis (up and down) with the planet's gravity direciton:
	if current_planet != centralStar:
		state.transform.basis.y = -gravity_direction

func _check_if_central_star():
	var body_is_inside_planet_areas = false
	
	for planet in planets:
		if planet.is_body_inside_area:
			body_is_inside_planet_areas = true
			break
	
	if !body_is_inside_planet_areas:
		current_planet = centralStar
		print("centralStar")
		
		
func prevent_player_from_falling():
	if current_planet == centralStar:
		#pass
		#TO-DO: make this good
		set_linear_velocity(Vector3(0, 0, 0))
	else:
		set_linear_velocity(gravity_direction * 10)

func _on_Area_body_entered(body):
	pass

func _on_Area_body_exited(body):
	_check_if_central_star()
	pass

func _move():
	if Input.is_action_pressed("ui_backwards"):
		add_central_force(move_force * global_transform.basis.z)
		
	if Input.is_action_pressed("ui_forwards"):
		add_central_force(move_force * -global_transform.basis.z)

	if Input.is_action_pressed("ui_right"):
		add_central_force(move_force * -global_transform.basis.z)
		add_central_force(move_force * global_transform.basis.x)
		rotate_object_local(Vector3.DOWN, 0.01)

	if Input.is_action_pressed("ui_left"):
		add_central_force(move_force * -global_transform.basis.z)
		add_central_force(move_force * -global_transform.basis.x)
		rotate_object_local(Vector3.UP, 0.01)
		
	if Input.is_action_pressed("ui_up"):
		rotate_object_local(Vector3.LEFT, 0.01)
		
	if Input.is_action_pressed("ui_down"):
		rotate_object_local(Vector3.RIGHT, 0.01)
		
	if Input.is_action_pressed("ui_rollright"):
		rotate_object_local(Vector3.FORWARD, 0.01)
		
	if Input.is_action_pressed("ui_rollleft"):
		rotate_object_local(Vector3.BACK, 0.01)
	
	#jump:
	if Input.is_action_pressed("ui_space"):
		if can_jump:
			apply_impulse(Vector3.UP, jump_force * global_transform.basis.y)


func _on_PlanetGroundArea_body_entered(body):
	_check_if_can_jump()


func _on_PlanetGroundArea_body_exited(body):
	#_check_if_can_jump()
	pass


func _on_CentralBodyArea_body_entered(body):
	print("CentralBodyArea_body_entered")
	add_child(game_control_instance)
